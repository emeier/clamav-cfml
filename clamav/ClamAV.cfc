<cfcomponent output="false">

    <!--- static --->
    <cfset variables.NO_VIRUS_DETECTED = 0 />
    <cfset variables.VIRUS_DETECTED = 1 />
    <cfset variables.TIMEOUT = 15 />

    <!--- constructor --->
    <cffunction name="init" output="false">
        <cfargument name="clamdscanPath" type="string" default="/usr/bin/clamdscan" />

        <cfset variables.clamdscanPath = arguments.clamdscanPath />

        <cfreturn this />
    </cffunction>

    <!--- public --->
    <cffunction name="scan" returntype="struct" output="false"
        hint="Scans a file for viruses. Clamav returns an exit value of 0 if clean, 1 if infected and 2 if there was an error.">
        <cfargument name="filename" type="string" required="true" />

        <cfscript>
            local.result = {};
            local.command = [ variables.clamdscanPath, "--fdpass", arguments.filename ];

            try {
                local.process = createObject( "java", "java.lang.Runtime" ).getRuntime().exec(local.command);

                local.process.waitFor();
                local.result["exitValue"] = local.process.exitValue();
                local.result["stdErr"] = processStream(local.process.getErrorStream());
                local.result["stdOut"] = processStream(local.process.getInputStream());

                local.result["virusDetected"] = local.result.exitValue EQ variables.VIRUS_DETECTED ? true : false;

            } catch(any e) {
                writeLog("#e.message# #e.detail#", "Error", false, "clamav");
                local.result["virusDetected"] = false;
            }

            return local.result;
        </cfscript>
    </cffunction>

    <!--- private --->
    <cffunction name="processStream" output="false">
        <cfargument name="streamInput" type="any" required="true" />

        <cfscript>
            local.result = "";
            local.streamReader = createObject("java", "java.io.InputStreamReader").init(arguments.streamInput);
            local.buffererdReader = createObject("java", "java.io.BufferedReader").init(local.streamReader);

            local.line = local.buffererdReader.readLine();

            while(NOT isNull(local.line)) {
                local.result = local.result & local.line;
                local.line = local.buffererdReader.readLine();
            }

            return local.result;
        </cfscript>
    </cffunction>

</cfcomponent>
