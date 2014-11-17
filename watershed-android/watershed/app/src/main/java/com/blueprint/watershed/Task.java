package com.blueprint.watershed;

import android.util.Log;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.*;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import org.json.JSONObject;

/**
 * Object to represent Tasks in Watershed Project application
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Task {

    private ObjectMapper mMapper = new ObjectMapper();

    private Integer mId;
    private String mTitle;
    private String mDescription;
    private Integer mSiteId;
    private Integer mAssigneeId;
    private Integer mAssignerId;
    private Boolean mComplete;
    private Date mDueDate;
    private Date mUpdatedAt;
    private Date mCreatedAt;

    public Task(){
    }

    public Integer getId() {return mId;}
    public String getTitle() { return mTitle; }
    public String getDescription() { return mDescription; }
    public Integer getSiteId() { return mSiteId; }
    public Integer getAssigneeId() { return mAssigneeId; }
    public Integer getAssignerId() { return mAssignerId; }
    public Boolean getComplete() { return mComplete; }
    public Date getDueDate() { return mDueDate; }
    public Date getUpdatedAt() { return mUpdatedAt; }
    public Date getCreatedAt() {return mCreatedAt;}

    public void setId(Integer Id){ mId = Id;}
    public void setTitle (String title){
        mTitle = title;
    }
    public void setDescription(String description){
        mDescription = description;
    }
    public void setSiteId(Integer siteId){ mSiteId = siteId; }
    public void setAssigneeId(Integer assigneeId) {
        mAssigneeId = assigneeId;
    }
    public void setAssignerId(Integer assignerId){
        mAssignerId = assignerId;
    }
    public void setComplete(Boolean taskComplete){mComplete = taskComplete;}
    public void setDueDate(Date dueDate){
        mDueDate = dueDate;
    }
    public void setUpdatedAt(Date updatedAt) { mUpdatedAt = updatedAt;}
    public void setCreatedAt(Date createdAt) { mCreatedAt = createdAt;}
}
