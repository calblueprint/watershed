package com.blueprint.watershed.Tasks.TaskList;

import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskDetailFragment;

import java.text.DateFormatSymbols;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

/**
 * A Custom Adapter for the Task Object
 * Code heavily reference from http://www.ezzylearning.com/tutorial/customizing-android-listview-items-with-custom-arrayadapter
 *
 */
public class TaskAdapter extends BaseExpandableListAdapter {

    private MainActivity mParentActivity;
    private List<String> mHeaders;
    private HashMap<String, List<Task>> mData;

    public TaskAdapter(MainActivity activity, List<String> headers, HashMap<String, List<Task>> data){
        super();
        mParentActivity = activity;
        mHeaders = headers;
        mData = data;
    }

    public void updateData(HashMap<String, List<Task>> data) {
        mData = data;
        notifyDataSetChanged();
    }

    public void updateHeaders(List<String> headers) {
        mHeaders = headers;
        notifyDataSetChanged();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        List<Task> tasks = mData.get(mHeaders.get(groupPosition));
        return tasks == null ? 0 : tasks.size();
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) { return true; }

    @Override
    public long getChildId(int groupPosition, int childPosition) { return getChild(groupPosition, childPosition).getId(); }

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
            LayoutInflater inflater = mParentActivity.getLayoutInflater();
            row = inflater.inflate(R.layout.task_list_row, parent, false);

            holder = new TaskHolder();

            holder.mColor = row.findViewById(R.id.task_list_row_color);
            holder.mTitle = (TextView) row.findViewById(R.id.task_list_row_title);
            holder.mSite = (TextView) row.findViewById(R.id.task_list_row_site);
            holder.mDay = (TextView) row.findViewById(R.id.task_list_row_due_day);
            holder.mMonth = (TextView) row.findViewById(R.id.task_list_row_due_month);
            holder.mYear = (TextView) row.findViewById(R.id.task_list_row_due_year);
            holder.mDateHolder = (LinearLayout) row.findViewById(R.id.task_list_row_due_holder);
            row.setTag(holder);
        } else {
            holder = (TaskHolder) row.getTag();
        }

        final Task task = getChild(groupPosition, childPosition);

        if (task.getDueDate() != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(task.getDueDate());
            holder.mDay.setText(String.valueOf(cal.get(Calendar.DAY_OF_MONTH)));
            holder.mMonth.setText(new DateFormatSymbols().getMonths()[cal.get(Calendar.MONTH) - 1].substring(0, 3));
            holder.mYear.setText(String.valueOf(cal.get(Calendar.YEAR)));
        }

        holder.mSite.setText(task.getMiniSite().getName());
        holder.mTitle.setText(task.getTitle());

        int textColor;
        int backgroundColor;
        if (task.getColor() != null) {
            textColor = mParentActivity.getResources().getColor(R.color.white);
            backgroundColor = Color.parseColor(task.getColor());
        } else {
            textColor = mParentActivity.getResources().getColor(R.color.black);
            backgroundColor = mParentActivity.getResources().getColor(R.color.white);
        }
        
        holder.mColor.setBackgroundColor(backgroundColor);
        holder.mDateHolder.setBackgroundColor(backgroundColor);
        holder.mDay.setTextColor(textColor);
        holder.mMonth.setTextColor(textColor);
        holder.mYear.setTextColor(textColor);
        
        row.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mParentActivity.replaceFragment(TaskDetailFragment.newInstance(task));
            }
        });
        
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
        TaskHeaderHolder holder;

        if (row == null) {
            LayoutInflater inflater = mParentActivity.getLayoutInflater();
            holder = new TaskHeaderHolder();

            row = inflater.inflate(R.layout.task_list_header, parent, false);
            holder.mTitle = (TextView) row.findViewById(R.id.task_list_header_title);

            row.setTag(holder);
        } else {
            holder = (TaskHeaderHolder) row.getTag();
        }

        String taskHeader = getGroup(groupPosition);
        holder.mTitle.setText(taskHeader);

        return row;
    }

    @Override
    public boolean hasStableIds() { return false; }


    static class TaskHolder {
        View mColor;
        TextView mTitle;
        TextView mSite;
        TextView mDay;
        TextView mMonth;
        TextView mYear;
        LinearLayout mDateHolder;
    }

    static class TaskHeaderHolder {
        TextView mTitle;
    }
}
