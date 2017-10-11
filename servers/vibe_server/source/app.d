import vibe.vibe;

void main()
{
	auto settings = new HTTPServerSettings;
	settings.port = 9292;
	settings.bindAddresses = ["::1", "0.0.0.0"];
	listenHTTP(settings, &hello);
	runApplication();
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeBody("Hello World");
}
