package com.sample;



import java.io.InputStream;
import java.io.StringReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;









import javax.ejb.Stateless;
 
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.container.AsyncResponse;
import javax.ws.rs.container.Suspended;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;


@Stateless
@Path("/service")
public class SimpleRESTService {

	@PersistenceContext
	EntityManager em;

 
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public List<Person> getPersonList() 

	{
		 
		Query query = em.createQuery("FROM Person");
		List<Person> customerList = query.getResultList();
		return customerList;
	} 


	@POST
	@Path("/save")
	@Consumes(MediaType.APPLICATION_JSON)
    public void save(String message) {
	
		 JsonReader reader = Json.createReader(new StringReader(message));
		 JsonObject obj = reader.readObject();
		 String name = obj.getString("name");
		 String surname = obj.getString("surname");
		 String address = obj.getString("address");
		 
		 Query query = em.createQuery("FROM Person where name = :name and surname = :surname");
		 query.setParameter("name", name);
		 query.setParameter("surname", surname);
		 Person person = (Person) query.getSingleResult();
		 person.setAddress(address);
		 em.persist(person);

		 
    }
	@PUT
	@Consumes(MediaType.APPLICATION_JSON)
    public void newPerson(String message) {

		 JsonReader reader = Json.createReader(new StringReader(message));
		 JsonObject obj = reader.readObject();
		 String name = obj.getString("name");
		 String surname = obj.getString("surname");
		 String address = obj.getString("address");
		 Person person = new Person();
		 person.setName(name);
		 person.setSurname(surname);
		 person.setAddress(address);
		 
		 em.persist(person);

		 
    }
	@POST
	@Consumes(MediaType.APPLICATION_JSON)
	@Path("/delete")
    public void delete(String message) {

		 JsonReader reader = Json.createReader(new StringReader(message));
		 JsonObject obj = reader.readObject();
		 String name = obj.getString("name");
		 String surname = obj.getString("surname");
		 	 
		 Query query = em.createQuery("delete FROM Person where name = :name and surname = :surname");
		 query.setParameter("name", name);
		 query.setParameter("surname", surname);
		 query.executeUpdate();
		 

		 
    }
}
