using System;
using System.Linq;
using System.Reflection;

/*
Requires this in .csproj:
    <Deterministic>false</Deterministic>
    <GenerateAssemblyInformationalVersionAttribute>false</GenerateAssemblyInformationalVersionAttribute>
    <GenerateAssemblyVersionAttribute>false</GenerateAssemblyVersionAttribute>
*/

[assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyInformationalVersion("GITHASH")] // Set to git hash in build file

namespace BuildScriptToDockerfile
{
    public static class AssemblyInfoHelper
    {

        public static string GetBuildDate()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            Version ver = assembly.GetName().Version;
            int build = ver.Build;
            int rev = ver.Revision;

            // http://channel9.msdn.com/forums/Coffeehouse/255737-AssemblyInfo-Version-Numbers/
            DateTime buildDate = new DateTime(2000, 1, 1);
            buildDate = buildDate.AddDays(build);
            buildDate = buildDate.AddSeconds(rev * 2);
            string buildDateString = buildDate.ToString("G");

            return buildDateString;
        }

        public static string GetGitHash()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            string versionDescription = (
                    from a in assembly.GetCustomAttributes(typeof(AssemblyInformationalVersionAttribute), false)
                    select a as AssemblyInformationalVersionAttribute
            ).First().InformationalVersion;
            return versionDescription;
        }

    }
}
