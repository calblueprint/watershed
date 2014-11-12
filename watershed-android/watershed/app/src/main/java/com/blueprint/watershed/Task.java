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

    /** The title of the task**/
    private String mTitle;
    /** Description of task **/
    private String mDescription;
    /** site id that the action takes place at **/
    private Integer mSiteId;
    /** id of user assigned to task **/
    private Integer mAssigneeId;
    /** id of user who assigned the task **/
    private Integer mAssignerId;
    /** is the task complete? **/
    private Boolean mTaskComplete;
    /** task due date **/
    private Date mDueDate;

    public Task(String title, String description,
                Integer siteId, Integer assigneeId, Integer assignerId,
                Boolean taskComplete, Date dueDate) {
        mTitle = title;
        mDescription = description;
        mSiteId = siteId;
        mAssigneeId = assigneeId;
        mAssignerId = assignerId;
        mTaskComplete = taskComplete;
        mDueDate = dueDate;
    }

    public Task(){
    }

    public String getTitle() { return mTitle; }
    public String getDescription() { return mDescription; }
    public Integer getSiteId() { return mSiteId; }
    public Integer getAssigneeId() { return mAssigneeId; }
    public Integer getAssignerId() { return mAssignerId; }
    public Boolean getTaskComplete() { return mTaskComplete; }
    public Date getDueDate() { return mDueDate; }

    public void setTitle (String title){
        mTitle = title;
    }
    public void setDescription(String description){
        mDescription = description;
    }
    public void setAssigneeId(Integer assigneeId) {
        mAssigneeId = assigneeId;
    }
    public void setAssignerId(Integer assingerId){
        mAssignerId = assingerId;
    }
    public void setTaskComplete(Boolean taskComplete){
        mTaskComplete = taskComplete;
    }
    public void setDueDate(Date dueDate){
        mDueDate = dueDate;
    }

    //probably doesn't work yet. Should serialize the Task to JSON
//    public void Serializer(){
//        try {
//            mMapper.writeValue(new File("task.json"), this);
//        }
//        catch (JsonGenerationException ex) {
//            //handle exception
//        }
//        catch (JsonMappingException ex2) {
//            //handle exception
//        }
//        catch (IOException ex3) {
//            //handle exception
//        }
//    }
}
