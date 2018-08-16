// This file contains your Data Connector logic
section JamfPro___Get_Patch_Details;

[DataSource.Kind="JamfPro___Get_Patch_Details", Publish="JamfPro___Get_Patch_Details.Publish"]
shared JamfPro___Get_Patch_Details.Contents = (website as text, patchID as text) =>
    let
        token = GetJamfProToken(website),
        source = GetPatchReport(website, token, patchID)

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

GetPatchReport = (website as text, token as text, patchID as text) =>
    let
        source = Web.Contents(website & "/uapi/patch/obj/" & patchID,
        [
            Headers = [#"Authorization" = "jamf-token " & token,
                #"Accepts" = "application/json"]]),
        json = Json.Document(source)
    in
        json;

// Data Source Kind description
JamfPro___Get_Patch_Details = [
    Authentication = [
        // Key = [],
        UsernamePassword = []
        // Windows = [],
        //Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
JamfPro___Get_Patch_Details.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = JamfPro___Get_Patch_Details.Icons,
    SourceTypeImage = JamfPro___Get_Patch_Details.Icons
];

JamfPro___Get_Patch_Details.Icons = [
    Icon16 = { Extension.Contents("JamfPro___Get_Patch_Details16.png"), Extension.Contents("JamfPro___Get_Patch_Details20.png"), Extension.Contents("JamfPro___Get_Patch_Details24.png"), Extension.Contents("JamfPro___Get_Patch_Details32.png") },
    Icon32 = { Extension.Contents("JamfPro___Get_Patch_Details32.png"), Extension.Contents("JamfPro___Get_Patch_Details40.png"), Extension.Contents("JamfPro___Get_Patch_Details48.png"), Extension.Contents("JamfPro___Get_Patch_Details64.png") }
];
