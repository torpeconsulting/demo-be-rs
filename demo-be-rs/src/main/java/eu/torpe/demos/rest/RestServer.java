package eu.torpe.demos.rest;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

/**
 * @author Pedro Torrao <pedro.torrao@torpe.eu>
 */

@Path("/v1")
public class RestServer {
    @Inject
    EchoService echoService;

    @GET
    @Path("/ping")
    @Produces({ "text/plain" })
    public String ping() {
        return "It's alive!";
    }

    @GET
    @Path("/echo/{token}")
    @Produces({ "application/json" })
    public String echo(@PathParam("token") String token) {
        return "{\"result\":\"" + echoService.echo(token) + "\"}";
    }
}
