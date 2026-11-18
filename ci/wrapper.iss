; wrapper.iss — SamAI 通用 Windows 包装器
; 所有参数经 ISCC /D 注入：
;   /DMyAppName=... /DAppId=... /DExeName=... /DMyAppVersion=...
;   /DOutputBaseFilename=... /DCnMessages=<isl> [/DExeDesc=...]
; 载荷放在本文件同级的 stage\ 目录（递归整包安装到 {app}）。

#ifndef MyAppName
#define MyAppName "SamAI App"
#endif
#ifndef AppId
#define AppId "SAMAI-APP-2026"
#endif
#ifndef ExeName
#define ExeName "app.exe"
#endif
#ifndef MyAppVersion
#define MyAppVersion "0.0.0"
#endif
#ifndef OutputBaseFilename
#define OutputBaseFilename "setup-{#MyAppVersion}"
#endif

[Setup]
AppId={#AppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher=samai.cc
AppPublisherURL=https://samai.cc
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=dist
OutputBaseFilename={#OutputBaseFilename}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\{#ExeName}
ArchitecturesInstallIn64BitMode=x64compatible
ArchitecturesAllowed=x64compatible
SetupLogging=yes

#ifdef CnMessages
[Languages]
Name: "chinesesimp"; MessagesFile: "{#CnMessages}"
Name: "english"; MessagesFile: "compiler:Default.isl"
#else
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
#endif

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "addpath"; Description: "加入 PATH 环境变量（命令行可直接调用）/ Add to PATH"; GroupDescription: "其他选项 / Additional tasks:"; Flags: unchecked

[Files]
Source: "stage\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#ExeName}"
Name: "{group}\卸载 {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#ExeName}"; Tasks: desktopicon

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
    ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; \
    Tasks: addpath; Flags: uninsdeletevalueifempty dontcreatekey

[Run]
Filename: "{app}\{#ExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
