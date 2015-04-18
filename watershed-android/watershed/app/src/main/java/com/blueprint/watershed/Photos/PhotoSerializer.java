package com.blueprint.watershed.Photos;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by charlesx on 4/7/15.
 * Serializes photos
 */
public class PhotoSerializer extends JsonSerializer<Photo> {

    @Override
    public void serialize(Photo value, JsonGenerator jgen, SerializerProvider provider)
            throws IOException {
        jgen.writeStartObject();
        jgen.writeNumberField("id", value.getId());
        jgen.writeStringField("url", value.getURL());
        jgen.writeObjectField("created_at", value.getCreatedAt());
        jgen.writeEndObject();
    }
}
