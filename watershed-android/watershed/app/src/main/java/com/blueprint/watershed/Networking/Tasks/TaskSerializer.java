package com.blueprint.watershed.Networking.Tasks;

import com.blueprint.watershed.Tasks.Task;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

/**
 * Created by charlesx on 3/3/15.
 * Maps Task to json
 */
public class TaskSerializer extends JsonSerializer<Task> {
    @Override
    public void serialize(Task value, JsonGenerator jgen, SerializerProvider provider)
            throws IOException {
        jgen.writeStartObject();
        jgen.writeStringField("title", value.getTitle());
        jgen.writeStringField("description", value.getDescription());
        jgen.writeNumberField("mini_site_id", value.getMiniSiteId());
        jgen.writeNumberField("assigner_id", value.getAssignerId());
        if (value.getAssigneeId() != null) jgen.writeNumberField("assignee_id", value.getAssigneeId());
        if (value.getComplete() != null) jgen.writeBooleanField("complete", value.getComplete());

        DateFormat format = new SimpleDateFormat("yyyy/MM/dd");
        format.setTimeZone(TimeZone.getTimeZone("UTC"));
        String date = format.format(value.getDueDate());
        jgen.writeStringField("due_date", date);

        if (value.getUrgent() != null) jgen.writeBooleanField("urgent", value.getUrgent());
        jgen.writeEndObject();
    }
}
