public class JsonNode{
        public String id {get;set;}
        public String text {get;set;}
        public String qtip {get;set;}
        public boolean expanded {get;set;}
        public boolean leaf {get;set;}
        public String pageRef {get;set;}
        public String href {get;set;}
        public map<String,JsonNode> childrenMap {get; set;}        
        public integer nodeCount {get; set;}
        
        public JsonNode(){
            id = '';
            text = '';
            expanded = false;
            leaf = true;
            href = '#';
            pageRef = '';
            nodeCount = 0;
            qtip = '';
            childrenMap = new map<String,JsonNode>();
        }
        
        public void addChild(JsonNode childNode){
            nodeCount ++;
            childrenMap.put(nodeCount+'', childNode);
        }
        
        public String toJsonString(){
            return '['+makeJsonString()+']'; 
        }
        
        public String makeJsonString(){
            String jsonStr = ' { ';
            jsonStr += ' id:\''+id+'\',';
            jsonStr += ' text:\''+text+'\',';
            jsonStr += ' pageRef :\''+ pageRef  +'\',';
            String tip = '';
            if(qtip != null) tip = qtip.replaceAll('\'','\\\'');
            jsonStr += ' qtip:\''+tip+'\',';
            jsonStr += ' expanded:'+expanded+',';
            jsonStr += ' leaf:'+leaf+',';
            jsonStr += ' href:\''+href+'\'';
            if(childrenMap != null && childrenMap.size()>0){
                jsonStr += ',';
                jsonStr += ' children : [ ';
                jsonStr += getJsonChildString();
                jsonStr += ' ] ';
            }
            jsonStr += ' } ';
            return jsonStr;
        }
        
        public String getJsonChildString(){
            String jsonChildStr = '';
                for(integer i=1; i<(nodeCount+1);i++){
                    jsonChildStr += childrenMap.get(i+'').makeJsonString();
                    if(i != nodeCount) jsonChildStr += ',';
                }
            return jsonChildStr;
        }
        
        public String getJsonChildArrayString(){
            return '[' + getJsonChildString() + ']';
        }
    }
			                            	