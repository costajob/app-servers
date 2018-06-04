import vibe.d;

void main()
{
    auto settings = new HTTPServerSettings;
    settings.port = 9292;
    settings.bindAddresses = ["::1", "0.0.0.0"];
    listenHTTP(settings, (req, res) { res.writeBody("Hello World"); });
    runApplication();
}
