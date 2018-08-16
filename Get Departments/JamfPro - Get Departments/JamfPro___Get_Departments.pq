// This file contains your Data Connector logic
section JamfPro___Get_Departments;

[DataSource.Kind="JamfPro___Get_Departments", Publish="JamfPro___Get_Departments.Publish"]
shared JamfPro___Get_Departments.Contents = (optional message as text) =>
    let
        token = GetJamfProToken(website),
        source = GetPatchReport(website, token)

    in
        source;
GetJamfProToken = (website as text) =>
    let
        username = Record.Field(Extension.CurrentCredential(), "Username"),
        password = Record.Field(Extension.CurrentCredential(), "Password"),
        bytes = Text.ToBinary(username & ":" & password),
        credentials = Binary.ToText(bytes, BinaryEncoding.Base64),
        source = Web.Contents(website & "/uapi/auth/tokens",
        [
            Headers = [#"Authorization" = "Basic " & credentials,
                #"Accepts" = "application/json"],
            Content=Text.ToBinary(" ")
        ]),
        json = Json.Document(source),
        first = Record.Field(json,"token"),
        auth = Extension.CurrentCredential(),
        auth2 = Record.Field(auth, "Password")
    in
        first;

GetPatchReport = (website as text, token as text) =>
    let
        source = Web.Contents(website & "/uapi/settings/obj/department",
        [
            Headers = [#"Authorization" = "jamf-token " & token,
                #"Accepts" = "application/json"]]),
        json = Json.Document(source)
    in
        json;

// Data Source Kind description
JamfPro___Get_Departments = [
    Authentication = [
        // Key = [],
        UsernamePassword = []
        // Windows = [],
        //Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
JamfPro___Get_Departments.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = JamfPro___Get_Departments.Icons,
    SourceTypeImage = JamfPro___Get_Departments.Icons
];

JamfPro___Get_Departments.Icons = [
    Icon16 = { Extension.Contents("JamfPro___Get_Departments16.png"), Extension.Contents("JamfPro___Get_Departments20.png"), Extension.Contents("JamfPro___Get_Departments24.png"), Extension.Contents("JamfPro___Get_Departments32.png") },
    Icon32 = { Extension.Contents("JamfPro___Get_Departments32.png"), Extension.Contents("JamfPro___Get_Departments40.png"), Extension.Contents("JamfPro___Get_Departments48.png"), Extension.Contents("JamfPro___Get_Departments64.png") }
];
