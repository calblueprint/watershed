package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * A Custom Adapter for the Task Object
 * Code heavily reference from http://www.ezzylearning.com/tutorial/customizing-android-listview-items-with-custom-arrayadapter
 *
 */
public class TaskAdapter extends BaseExpandableListAdapter {

    private Context mContext;
    private List<String> mHeaders;
    private HashMap<String, List<Task>> mData;

    public TaskAdapter(Context context, List<String> headers, HashMap<String, List<Task>> data){
        super();
        mContext = context;
        mHeaders = headers;
        mData = data;
    }

    @Override
    public int getChildrenCount(int groupPosition) { return mData.get(mHeaders.get(groupPosition)).size(); }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) { return true; }

    @Override
    public long getChildId(int groupPosition, int childPosition) { return childPosition; }

    @Override
    public Task getChild(int groupPosition, int childPosition) {
        return mData.get(mHeaders.get(groupPosition))
                    .get(childPosition);
    }

    @Override
    public View getChildView(int groupPosition, int childPosition,
                             boolean isLastChild, View convertView, ViewGroup parent) {
        View row = convertView;
        TaskHolder holder;

        if (row == null) {
            LayoutInflater inflater = ((Activity) mContext).getLayoutInflater();
            row = inflater.inflate(R.layout.task_list_row, parent, false);

            holder = new TaskHolder();
            holder.title = (TextView) row.findViewById(R.id.title);
            holder.description = (TextView) row.findViewById(R.id.description);
            holder.site = (TextView) row.findViewById(R.id.site);
            holder.due_date = (TextView) row.findViewById(R.id.due_date);

            row.setTag(holder);
        } else {
            holder = (TaskHolder) row.getTag();
        }

        Task task = getChild(groupPosition, childPosition);
        holder.description.setText(task.getDescription());
        if (task.getDueDate() != null) {
            holder.due_date.setText(parseDate(task.getDueDate()));
        }
        holder.site.setText("Minisite " + Integer.toString(task.getMiniSiteId()));

        holder.title.setText(task.getTitle());
        return row;
    }

    @Override
    public int getGroupCount() { return mHeaders.size(); }

    @Override
    public long getGroupId(int groupPosition) { return groupPosition; }

    @Override
    public String getGroup(int groupPosition) { return mHeaders.get(groupPosition); }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        View row = convertView;
        TaskHolder holder;

        if (row == null) {
            LayoutInflater inflater = ((Activity) mContext).getLayoutInflater();
            holder = new TaskHolder();

            row = inflater.inflate(R.layout.task_list_header, parent, false);
            holder.title = (TextView) row.findViewById(R.id.task_list_header_title);

            row.setTag(holder);
        } else {
            holder = (TaskHolder) row.getTag();
        }

        String taskHeader = getGroup(groupPosition);
        holder.title.setText(taskHeader);
        return row;
    }

    @Override
    public boolean hasStableIds() { return false; }

    private String parseDate(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int month = cal.get(Calendar.MONTH) + 1;
        int day = cal.get(Calendar.DAY_OF_MONTH);
        return month + "/" + day;
    }

    static class TaskHolder {
        TextView title;
        TextView description;
        TextView due_date;
        TextView site;
    }
}
