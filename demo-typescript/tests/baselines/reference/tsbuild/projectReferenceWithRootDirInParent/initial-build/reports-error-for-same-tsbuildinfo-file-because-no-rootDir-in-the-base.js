Input::
//// [/lib/lib.d.ts]
/// <reference no-default-lib="true"/>
interface Boolean {}
interface Function {}
interface CallableFunction {}
interface NewableFunction {}
interface IArguments {}
interface Number { toExponential: any; }
interface Object {}
interface RegExp {}
interface String { charAt: any; }
interface Array<T> { length: number; [n: number]: T; }
interface ReadonlyArray<T> {}
declare const console: { log(msg: any): void; };

//// [/src/src/main/a.ts]
import { b } from './b';
const a = b;

//// [/src/src/main/b.ts]
export const b = 0;


//// [/src/src/main/tsconfig.json]
{
  "extends": "../../tsconfig.base.json",
  "references": [
    { "path": "../other" }
  ]
}

//// [/src/src/other/other.ts]
export const Other = 0;


//// [/src/src/other/tsconfig.json]
{
  "extends": "../../tsconfig.base.json"
}

//// [/src/tsconfig.base.json]
{
  "compilerOptions": {
    "composite": true,
    "declaration": true,
    
    "outDir": "./dist/",
    "skipDefaultLibCheck": true
  },
  "exclude": [
    "node_modules"
  ]
}



Output::
/lib/tsc --b /src/src/main --verbose
[[90m12:00:00 AM[0m] Projects in this build: 
    * src/src/other/tsconfig.json
    * src/src/main/tsconfig.json

[[90m12:00:00 AM[0m] Project 'src/src/other/tsconfig.json' is out of date because output file 'src/dist/other.js' does not exist

[[90m12:00:00 AM[0m] Building project '/src/src/other/tsconfig.json'...

[[90m12:00:00 AM[0m] Project 'src/src/main/tsconfig.json' is out of date because output file 'src/dist/a.js' does not exist

[[90m12:00:00 AM[0m] Building project '/src/src/main/tsconfig.json'...

[96msrc/src/main/tsconfig.json[0m:[93m4[0m:[93m5[0m - [91merror[0m[90m TS6377: [0mCannot write file '/src/dist/tsconfig.tsbuildinfo' because it will overwrite '.tsbuildinfo' file generated by referenced project '/src/src/other'

[7m4[0m     { "path": "../other" }
[7m [0m [91m    ~~~~~~~~~~~~~~~~~~~~~~[0m


Found 1 error.

exitCode:: ExitStatus.DiagnosticsPresent_OutputsGenerated


//// [/src/dist/other.d.ts]
export declare const Other = 0;


//// [/src/dist/other.js]
"use strict";
exports.__esModule = true;
exports.Other = void 0;
exports.Other = 0;


//// [/src/dist/tsconfig.tsbuildinfo]
{
  "program": {
    "fileInfos": {
      "../../lib/lib.d.ts": {
        "version": "3858781397-/// <reference no-default-lib=\"true\"/>\ninterface Boolean {}\ninterface Function {}\ninterface CallableFunction {}\ninterface NewableFunction {}\ninterface IArguments {}\ninterface Number { toExponential: any; }\ninterface Object {}\ninterface RegExp {}\ninterface String { charAt: any; }\ninterface Array<T> { length: number; [n: number]: T; }\ninterface ReadonlyArray<T> {}\ndeclare const console: { log(msg: any): void; };",
        "signature": "3858781397-/// <reference no-default-lib=\"true\"/>\ninterface Boolean {}\ninterface Function {}\ninterface CallableFunction {}\ninterface NewableFunction {}\ninterface IArguments {}\ninterface Number { toExponential: any; }\ninterface Object {}\ninterface RegExp {}\ninterface String { charAt: any; }\ninterface Array<T> { length: number; [n: number]: T; }\ninterface ReadonlyArray<T> {}\ndeclare const console: { log(msg: any): void; };",
        "affectsGlobalScope": true
      },
      "../src/other/other.ts": {
        "version": "-2951227185-export const Other = 0;\r\n",
        "signature": "-7996259489-export declare const Other = 0;\r\n",
        "affectsGlobalScope": false
      }
    },
    "options": {
      "composite": true,
      "declaration": true,
      "outDir": "./",
      "skipDefaultLibCheck": true,
      "configFilePath": "../src/other/tsconfig.json"
    },
    "referencedMap": {},
    "exportedModulesMap": {},
    "semanticDiagnosticsPerFile": [
      "../../lib/lib.d.ts",
      "../src/other/other.ts"
    ]
  },
  "version": "FakeTSVersion"
}
