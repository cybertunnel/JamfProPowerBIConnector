// This file contains your Data Connector logic
section JamfPro___Get_Buildings;

[DataSource.Kind="JamfPro___Get_Buildings", Publish="JamfPro___Get_Buildings.Publish"]
shared JamfPro___Get_Buildings.Contents = (website as text) =>
    let
        token = GetJamfProToken(website),
        source = GetBuildings(website, token),
        table = GenerateTable(source)

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

GetBuildings = (website as text, token as text) =>
    let
        source = Web.Contents(website & "/uapi/settings/obj/building",
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
JamfPro___Get_Buildings = [
    Authentication = [
        // Key = [],
        UsernamePassword = []
        // Windows = [],
        //Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
JamfPro___Get_Buildings.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = JamfPro___Get_Buildings.Icons,
    SourceTypeImage = JamfPro___Get_Buildings.Icons
];

JamfPro___Get_Buildings.Icons = [
    Icon16 = { Extension.Contents("JamfPro___Get_Buildings16.png"), Extension.Contents("JamfPro___Get_Buildings20.png"), Extension.Contents("JamfPro___Get_Buildings24.png"), Extension.Contents("JamfPro___Get_Buildings32.png") },
    Icon32 = { Extension.Contents("JamfPro___Get_Buildings32.png"), Extension.Contents("JamfPro___Get_Buildings40.png"), Extension.Contents("JamfPro___Get_Buildings48.png"), Extension.Contents("JamfPro___Get_Buildings64.png") }
];
