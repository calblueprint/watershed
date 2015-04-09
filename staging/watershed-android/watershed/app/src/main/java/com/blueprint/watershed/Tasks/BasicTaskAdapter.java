package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

/**
 * A Custom Adapter for the Task Object
 * Code heavily reference from http://www.ezzylearning.com/tutorial/customizing-android-listview-items-with-custom-arrayadapter
 *
 */
public class BasicTaskAdapter extends ArrayAdapter<Task> {
    Context context;
    int layoutResourceId;
    ArrayList<Task> data = null;

    public BasicTaskAdapter(Context context, int layoutResourceId, ArrayList<Task> data){
        super(context, layoutResourceId, data);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.data = data;
    }

    @Override
    public View getView(int position,  View convertview, ViewGroup parent){
        View row = convertview;
        TaskHolder holder = null;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new TaskHolder();
            holder.title = (TextView)row.findViewById(R.id.title);
            holder.description = (TextView)row.findViewById(R.id.description);
            holder.site = (TextView) row.findViewById(R.id.site);
            holder.due_date = (TextView)row.findViewById(R.id.due_date);

            row.setTag(holder);
        }
        else
        {
            holder = (TaskHolder)row.getTag();
        }
        Task task = data.get(position);
        holder.title.setText(task.getTitle());
        holder.description.setText(task.getDescription());
        if (task.getDueDate() != null) {
            holder.due_date.setText(parseDate(task.getDueDate()));
        }
        holder.site.setText("Site " + Integer.toString(task.getMiniSiteId()));

        return row;
    }

    private String parseDate(Date date) {
        return DateFormat.getDateInstance().format(date);
    }

    static class TaskHolder
    {
        TextView title;
        TextView description;
        TextView due_date;
        TextView site;
    }
}