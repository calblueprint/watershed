package com.blueprint.watershed.Networking.MiniSites;

import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Photos.Photo;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by charlesx on 3/3/15.
 * Maps Mini site to json
 */
public class MiniSiteSerializer extends JsonSerializer<MiniSite> {

    @Override
    public void serialize(MiniSite value, JsonGenerator jgen, SerializerProvider provider)
            throws IOException, JsonProcessingException {
        jgen.writeStartObject();
        jgen.writeStringField("name", value.getName());
        jgen.writeStringField("description", value.getDescription());
        jgen.writeStringField("street", value.getStreet());
        jgen.writeStringField("city", value.getCity());
        jgen.writeStringField("state", value.getState());
        jgen.writeNumberField("zip_code", value.getZipCode());
        jgen.writeNumberField("latitude", value.getLatitude());
        jgen.writeNumberField("longitude", value.getLongitude());
        jgen.writeNumberField("site_id", value.getSiteId());
        jgen.writeArrayFieldStart("photos_attributes");
        for (Photo photo : value.getPhotos()) {
            jgen.writeStartObject();
            if (photo.getId() != null) jgen.writeNumberField("id", photo.getId());
            jgen.writeObjectField("data", photo.getData());
            jgen.writeEndObject();
        }
        jgen.writeEndArray();
        jgen.writeEndObject();
    }
}
