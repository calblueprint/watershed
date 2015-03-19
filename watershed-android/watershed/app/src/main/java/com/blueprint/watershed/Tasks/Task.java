package com.blueprint.watershed.Tasks;

import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Date;

/**
 * Object to represent Tasks in Watershed Project application
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Task implements APIObject {

    private ObjectMapper mMapper = new ObjectMapper();

    private Integer mId;
    private String mTitle;
    private String mDescription;
    private Integer mMiniSiteId;
    private Integer mAssigneeId;
    private Integer mAssignerId;
    private Boolean mComplete;
    private Date mDueDate;
    private Date mUpdatedAt;
    private Date mCreatedAt;

    private User mAssignee;
    private User mAssigner;
    private FieldReport mFieldReport;
    private MiniSite mMiniSite;

    public Task() {}

    public Task(String name) {
        super();
        setTitle(name);
    }

    public Integer getId() {return mId;}
    public String getTitle() { return mTitle; }
    public String getDescription() { return mDescription; }
    public Integer getMiniSiteId() { return mMiniSiteId; }
    public Integer getAssigneeId() { return mAssigneeId; }
    public Integer getAssignerId() { return mAssignerId; }
    public Boolean getComplete() { return mComplete; }
    public Date getDueDate() { return mDueDate; }
    @JsonIgnore
    public Date getUpdatedAt() { return mUpdatedAt; }
    @JsonIgnore
    public Date getCreatedAt() {return mCreatedAt;}

    public void setId(Integer Id){ mId = Id;}
    public void setTitle (String title){
        mTitle = title;
    }
    public void setDescription(String description){
        mDescription = description;
    }
    public void setMiniSiteId(Integer miniSiteId){ mMiniSiteId = miniSiteId; }
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

    public void setAssigner(User assigner) { mAssigner = assigner; }
    public User getAssigner() { return mAssigner; }
    public void setFieldReport(FieldReport assigner) { mFieldReport = assigner; }
    public FieldReport getFieldReport() { return mFieldReport; }
    public void setMiniSite(MiniSite assigner) { mMiniSite = assigner; }
    public MiniSite getMiniSite() { return mMiniSite; }
    public User getAssignee() { return mAssignee; }
    public void setAssignee(User mAssignee) { mAssignee = mAssignee; }

}
