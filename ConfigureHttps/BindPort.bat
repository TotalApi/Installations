/*
@echo off && cls
set WinDirNet=%WinDir%\Microsoft.NET\Framework
IF EXIST "%WinDirNet%\v2.0.50727\csc.exe" set csc="%WinDirNet%\v2.0.50727\csc.exe"
IF EXIST "%WinDirNet%\v3.5\csc.exe" set csc="%WinDirNet%\v3.5\csc.exe"
IF EXIST "%WinDirNet%\v4.0.30319\csc.exe" set csc="%WinDirNet%\v4.0.30319\csc.exe"
%csc% /platform:x86 /nologo /out:"%~0.exe" %0
%~d0
cd %~dp0
"%~0.exe" %1 %2 %3 %4 %5 %6 %7 %8
del "%~0.exe"
exit
*/

using System;
using System.Diagnostics;
using System.IO;
using System.Security.Cryptography.X509Certificates;

namespace BindCertToPort
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Certificate file path must be passed as the first parameter.");
                Console.ReadKey();
                return;
            }

            try 
            {
			    int port = int.Parse(args[0]);
                string certPath = args[1];
				string certPass = "";
                if (args.Length > 2)
                    certPass = args[2];
                
                X509Certificate2 certificate;
				if (certPass != "")
					certificate = new X509Certificate2(certPath, certPass, X509KeyStorageFlags.Exportable | X509KeyStorageFlags.MachineKeySet | X509KeyStorageFlags.PersistKeySet);
				else
				    certificate = new X509Certificate2(certPath);

                // netsh http add sslcert ipport=0.0.0.0:<port> certhash={<thumbprint>} appid={<some GUID>}
                Process bindPortToCertificate = new Process();
                bindPortToCertificate.StartInfo.FileName = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.SystemX86), "netsh.exe");

                bindPortToCertificate.StartInfo.Arguments = string.Format("http delete sslcert ipport=0.0.0.0:{0}", port);
                bindPortToCertificate.StartInfo.UseShellExecute = false;
                bindPortToCertificate.StartInfo.RedirectStandardOutput = true;
                Console.WriteLine("{0} {1}", bindPortToCertificate.StartInfo.FileName, bindPortToCertificate.StartInfo.Arguments);
                bindPortToCertificate.Start();
                Console.WriteLine(bindPortToCertificate.StandardOutput.ReadToEnd());
                bindPortToCertificate.WaitForExit();

                // Инсталлируем сертификат в хранилище LocalMachine
                //X509Store store = new X509Store(StoreName.TrustedPeople, StoreLocation.LocalMachine);
                X509Store store = new X509Store(StoreName.My, StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadWrite);
                store.Add(certificate); //where cert is an X509Certificate object
                store.Close(); 

                bindPortToCertificate.StartInfo.Arguments = string.Format("http add sslcert ipport=0.0.0.0:{0} certhash={1} appid={{{2}}}", port, certificate.Thumbprint, Guid.NewGuid());
                Console.WriteLine("{0} {1}", bindPortToCertificate.StartInfo.FileName, bindPortToCertificate.StartInfo.Arguments);
                bindPortToCertificate.Start();
                Console.WriteLine(bindPortToCertificate.StandardOutput.ReadToEnd());
                bindPortToCertificate.WaitForExit();
            }
            catch (Exception e) 
            {
                Console.WriteLine(e.Message);
                Console.ReadKey();
            }
        }
    }
}

