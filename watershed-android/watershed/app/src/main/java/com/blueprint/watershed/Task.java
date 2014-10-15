package com.blueprint.watershed;

import java.util.Date;

/**
 * Object to represent Tasks in Watershed Project application
 */
public class Task {



    /** The title of the task**/
    private String mtitle;
    /** Description of task **/
    private String mdescription;
    /** site id that the action takes place at **/
    private Integer msiteId;
    /** id of user assigned to task **/
    private Integer massigneeId;
    /** id of user who assigned the task **/
    private Integer massignerId;
    /** is the task complete? **/
    private Boolean mtaskComplete;
    /** task due date **/
    private Date mdueDate;

    public Task(String title, String description,
                Integer siteId, Integer assigneeId, Integer assignerId,
                Boolean taskComplete, Date dueDate) {
        mtitle = title;
        mdescription = description;
        msiteId = siteId;
        massigneeId = assigneeId;
        massignerId = assignerId;
        mtaskComplete = taskComplete;
        mdueDate = dueDate;
    }

    public Task(){
        mtitle = "Sweet Title";
        mdescription = "";
        msiteId = 0;
        massigneeId = 0;
        massignerId = 0;
        mtaskComplete = false;
        mdueDate = new Date();
    }

    public String getTitle() { return mtitle; }

    public String getDescription() { return mdescription; }

    public Integer getSiteId() { return msiteId; }

    public Integer getAssigneeId() { return massigneeId; }

    public Integer getAssignerId() { return massignerId; }

    public Boolean getTaskComplete() { return mtaskComplete; }

    public Date getDueDate() { return mdueDate; }

    public void setTitle (String title){
        mtitle = title;
    }

    public void setDescription(String description){
        mdescription = description;
    }

    public void setAssigneeId(Integer assigneeId) {
        massigneeId = assigneeId;
    }

    public void setAssignerId(Integer assingerId){
        massignerId = assingerId;
    }

    public void setTaskComplete(Boolean taskComplete){
        mtaskComplete = taskComplete;
    }

    public void setmdueDate(Date dueDate){
        mdueDate = dueDate;
    }

}
