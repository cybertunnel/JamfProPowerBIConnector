// This file contains your Data Connector logic
section JamfPro___Get_Mobile_Devices;

[DataSource.Kind="JamfPro___Get_Mobile_Devices", Publish="JamfPro___Get_Mobile_Devices.Publish"]
shared JamfPro___Get_Mobile_Devices.Contents = (website as text) =>
    let
        token = GetJamfProToken(website),
        source = GetMobileDevices(website, token),
        table = GenerateTable(source)s
    in
        table;

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

GetMobileDevices = (website as text, token as text) =>
    let
        source = Web.Contents(website & "/uapi/inventory/obj/mobileDevice",
        [
            Headers = [#"Authorization" = "jamf-token " & token,
                #"Accepts" = "application/json"]]),
        json = Json.Document(source)
    in
        json;

GenerateTable = (json as list) =>
    let
        source = Table.FromRecords(json)
    in
        source;
// Data Source Kind description
JamfPro___Get_Mobile_Devices = [
    Authentication = [
        // Key = [],
        UsernamePassword = []
        // Windows = [],
        //Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
JamfPro___Get_Mobile_Devices.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = JamfPro___Get_Mobile_Devices.Icons,
    SourceTypeImage = JamfPro___Get_Mobile_Devices.Icons
];

JamfPro___Get_Mobile_Devices.Icons = [
    Icon16 = { Extension.Contents("JamfPro___Get_Mobile_Devices16.png"), Extension.Contents("JamfPro___Get_Mobile_Devices20.png"), Extension.Contents("JamfPro___Get_Mobile_Devices24.png"), Extension.Contents("JamfPro___Get_Mobile_Devices32.png") },
    Icon32 = { Extension.Contents("JamfPro___Get_Mobile_Devices32.png"), Extension.Contents("JamfPro___Get_Mobile_Devices40.png"), Extension.Contents("JamfPro___Get_Mobile_Devices48.png"), Extension.Contents("JamfPro___Get_Mobile_Devices64.png") }
];
