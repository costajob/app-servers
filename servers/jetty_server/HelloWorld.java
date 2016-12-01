import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.eclipse.jetty.util.thread.QueuedThreadPool;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.server.handler.AbstractHandler;

public class HelloWorld extends AbstractHandler {

        @Override
        public void handle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
                response.setContentType("text/plain;charset=utf-8");
                response.setStatus(HttpServletResponse.SC_OK);
                baseRequest.setHandled(true);
                response.getWriter().println("Hello World");
        }

        public static void main(String[] args) throws Exception {
                QueuedThreadPool pool = new QueuedThreadPool();
                pool.setMaxThreads(50);
                Server server = new Server(pool);
                ServerConnector http = new ServerConnector(server);
                http.setPort(9292);
                server.addConnector(http);
                server.setHandler(new HelloWorld());
                server.start();
                server.join();
        }
}
