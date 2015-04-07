package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.blueprint.watershed.R;

import java.text.DateFormatSymbols;
import java.util.ArrayList;
import java.util.Calendar;

/**
 * A Custom Adapter for the Task Object
 * Code heavily reference from http://www.ezzylearning.com/tutorial/customizing-android-listview-items-with-custom-arrayadapter
 *
 */
public class BasicTaskAdapter extends ArrayAdapter<Task> {
    Context mContext;
    int mLayoutResourceId;
    ArrayList<Task> mData = null;

    public BasicTaskAdapter(Context context, int layoutResourceId, ArrayList<Task> data){
        super(context, layoutResourceId, data);
        mLayoutResourceId = layoutResourceId;
        mContext = context;
        mData = data;
    }

    @Override
    public View getView(int position,  View convertView, ViewGroup parent){
        View row = convertView;
        TaskHolder holder;

        if (row == null) {
            LayoutInflater inflater = ((Activity) mContext).getLayoutInflater();
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

        Task task = getItem(position);

        if (task.getDueDate() != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(task.getDueDate());
            holder.mDay.setText(String.valueOf(cal.get(Calendar.DAY_OF_MONTH)));
            holder.mMonth.setText(new DateFormatSymbols().getMonths()[cal.get(Calendar.MONTH)-1]);
            holder.mYear.setText(String.valueOf(cal.get(Calendar.YEAR)));
        }
        holder.mSite.setText(task.getMiniSite().getName());
        holder.mTitle.setText(task.getTitle());
        holder.mColor.setBackgroundColor(Color.parseColor(task.getColor()));
        holder.mDateHolder.setBackgroundColor(Color.parseColor(task.getColor()));
        return row;
    }

    @Override
    public Task getItem(int position) { return mData.get(position); }

    static class TaskHolder {
        View mColor;
        TextView mTitle;
        TextView mSite;
        TextView mDay;
        TextView mMonth;
        TextView mYear;
        LinearLayout mDateHolder;
    }
}