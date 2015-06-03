package com.blueprint.watershed.Networking.Sites;

import com.blueprint.watershed.Sites.Site;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by charlesx on 4/9/15.
 * Serializes a site.
 */
public class SiteSerializer extends JsonSerializer<Site> {
    @Override
    public void serialize(Site value, JsonGenerator jgen, SerializerProvider provider)
           throws IOException {
        jgen.writeStartObject();
        jgen.writeStringField("name", value.getName());
        jgen.writeStringField("description", value.getDescription());
        jgen.writeStringField("street", value.getStreet());
        jgen.writeNumberField("latitude", value.getLatitude());
        jgen.writeNumberField("longitude", value.getLongitude());
        jgen.writeEndObject();
    }
}
