package org.t246osslab.easybuggy4kt.controller

import org.apache.commons.lang3.StringUtils
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.dao.EmptyResultDataAccessException
import org.springframework.ldap.AuthenticationException
import org.springframework.ldap.core.LdapTemplate
import org.springframework.ldap.query.LdapQueryBuilder
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.servlet.ModelAndView
import org.t246osslab.easybuggy4kt.core.model.User
import java.io.IOException
import java.util.*
import java.util.concurrent.ConcurrentHashMap
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Controller
open class DefaultLoginController : AbstractController() {

    @Value("\${account.lock.time}")
    internal var accountLockTime: Long = 0

    @Value("\${account.lock.count}")
    internal var accountLockCount: Long = 0

    @Autowired
    protected var ldapTemplate: LdapTemplate? = null

    /* User's login history using in-memory account locking */
    companion object {
        protected var userLoginHistory: ConcurrentHashMap<String, User> = ConcurrentHashMap()
    }

    @RequestMapping(value = "/login", method = arrayOf(RequestMethod.GET))
    open fun doGet(mav: ModelAndView, req: HttpServletRequest, res: HttpServletResponse, locale: Locale): ModelAndView {
        setViewAndCommonObjects(mav, locale, "login")

        val hiddenMap = HashMap<String, Array<String>>()
        val paramNames = req.parameterNames
        while (paramNames.hasMoreElements()) {
            val paramName = paramNames.nextElement() as String
            hiddenMap.put(paramName, req.getParameterValues(paramName))
            mav.addObject("hiddenMap", hiddenMap)
        }

        val session = req.getSession(true)
        val authNMsg = session.getAttribute("authNMsg")
        if (authNMsg != null && "authenticated" != authNMsg) {
            mav.addObject("errmsg", authNMsg)
            session.setAttribute("authNMsg", null)
        }
        return mav
    }

    @RequestMapping(value = "/login", method = arrayOf(RequestMethod.POST))
    @Throws(IOException::class)
    open fun doPost(mav: ModelAndView, req: HttpServletRequest, res: HttpServletResponse, locale: Locale): ModelAndView? {

        val userid = StringUtils.trim(req.getParameter("userid"))
        val password = StringUtils.trim(req.getParameter("password"))

        val session = req.getSession(true)
        if (isAccountLocked(userid)) {
            session.setAttribute("authNMsg", msg?.getMessage("msg.authentication.fail", null, locale))
        } else if (authUser(userid, password)) {
            /* if authentication succeeded, then reset account lock */
            resetAccountLock(userid)

            session.setAttribute("authNMsg", "authenticated")
            session.setAttribute("userid", userid)

            val target = session.getAttribute("target") as String?
            if (target == null) {
                res.sendRedirect("/admins/main")
            } else {
                session.removeAttribute("target")
                res.sendRedirect(target)
            }
            return null
        } else {
            session.setAttribute("authNMsg", msg?.getMessage("msg.authentication.fail", null, locale))
        }
        /* account lock count +1 */
        incrementLoginFailedCount(userid)
        return doGet(mav, req, res, locale)
    }

    protected fun incrementLoginFailedCount(userid: String) {
        val admin = getUser(userid)
        admin.loginFailedCount = admin.loginFailedCount + 1
        admin.lastLoginFailedTime = Date()
    }

    protected fun resetAccountLock(userid: String) {
        val admin = getUser(userid)
        admin.loginFailedCount = 0
        admin.lastLoginFailedTime = null
    }

    protected fun getUser(userid: String): User {
        var admin: User? = userLoginHistory[userid]
        if (admin == null) {
            val newAdmin = User()
            newAdmin.userId = userid
            admin = userLoginHistory.putIfAbsent(userid, newAdmin)
            if (admin == null) {
                admin = newAdmin
            }
        }
        return admin
    }

    protected fun isAccountLocked(userid: String?): Boolean {
        if (userid == null) {
            return false
        }
        val admin = userLoginHistory[userid]
        return admin != null && admin.loginFailedCount >= accountLockCount
                && Date().time - admin.lastLoginFailedTime!!.time < accountLockTime
    }

    protected open fun authUser(userId: String?, password: String?): Boolean {
        if (userId == null || password == null) {
            return false
        }
        try {
            /* Perform a simple LDAP 'bind' authentication */
            val query = LdapQueryBuilder.query().where("uid").`is`(userId)
            ldapTemplate!!.authenticate(query, password)
        } catch (e: EmptyResultDataAccessException) {
            return false
        } catch (e: AuthenticationException) {
            return false
        } catch (e: Exception) {
            log.error("Exception occurs: ", e)
            return false
        }

        return true
    }
}
