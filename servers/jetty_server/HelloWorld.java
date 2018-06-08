import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.servlet.ServletHandler;
import org.eclipse.jetty.util.thread.QueuedThreadPool;

public class HelloWorld
{
	public static void main(String[] args) throws Exception
        {
                QueuedThreadPool threadPool = new QueuedThreadPool(15, 5);
                Server server = new Server(threadPool);
                ServerConnector connector = new ServerConnector(server);
                connector.setPort(9292);
                server.setConnectors(new Connector[]{connector});

                ServletHandler servletHandler = new ServletHandler();
                server.setHandler(servletHandler);

                servletHandler.addServletWithMapping(HelloServlet.class, "/");

                server.start();
                server.join();
	}
	
	public static class HelloServlet extends HttpServlet 
	{		
		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
		{
                        response.setContentType("text/plain; charset=utf-8");
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().println("Hello World"); 
                }
        } 
}
