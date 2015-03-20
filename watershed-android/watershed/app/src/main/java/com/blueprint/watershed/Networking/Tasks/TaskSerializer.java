package com.blueprint.watershed.Networking.Tasks;

import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Tasks.Task;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.text.SimpleDateFormat;

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
        MiniSite mini = value.getMiniSite();
        jgen.writeNumberField("mini_site_id", mini.getId());
        jgen.writeNumberField("assigner_id", value.getAssignerId());
        jgen.writeNumberField("assignee_id", value.getAssigneeId());
        if (value.getComplete() != null) jgen.writeBooleanField("complete", value.getComplete());
        jgen.writeStringField("due_date", new SimpleDateFormat("yyyy/MM/dd").format(value.getDueDate()));
        if (value.getUrgent() != null) jgen.writeBooleanField("urgent", value.getUrgent());
        jgen.writeEndObject();
    }
}
