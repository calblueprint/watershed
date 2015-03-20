package com.blueprint.watershed.Networking.FieldReports;

import com.blueprint.watershed.FieldReports.FieldReport;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

/**
 * Created by charlesx on 3/3/15.
 * Maps Mini site to json
 */
public class FieldReportSerializer extends JsonSerializer<FieldReport> {

    @Override
    public void serialize(FieldReport value, JsonGenerator jgen, SerializerProvider provider)
            throws IOException {
        jgen.writeStartObject();
        jgen.writeStringField("description", value.getDescription());
        jgen.writeNumberField("user_id", value.getUser().getId());
        jgen.writeNumberField("mini_site_id", value.getMiniSite().getId());
        jgen.writeNumberField("health_rating", value.getHealthRating());
        jgen.writeBooleanField("urgent", value.getUrgent());
        jgen.writeNumberField("task_id", value.getTask().getId());
        jgen.writeObjectFieldStart("photo_attributes");
        if (value.getPhoto().getId() != null) jgen.writeNumberField("id", value.getPhoto().getId());
        jgen.writeObjectField("data", value.getPhoto().getData());
        jgen.writeEndObject();
        jgen.writeEndObject();
    }
}
