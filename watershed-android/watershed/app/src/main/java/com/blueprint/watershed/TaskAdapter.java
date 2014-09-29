package com.blueprint.watershed;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * A Custom Adapter for the Task Object
 * Code heavily reference from http://www.ezzylearning.com/tutorial/customizing-android-listview-items-with-custom-arrayadapter
 *
 */
public class TaskAdapter extends ArrayAdapter<Task> {
    private Context mContext;
    private int mlayoutResourceId;
    private Task mdata[] = null;

    public TaskAdapter(Context context, int layoutResourceId, Task[] data){
        super(context, layoutResourceId, data);
        mContext = context;
        mdata = data;
    }

    @Override
    public View getView(int position,  View view, ViewGroup parent){
        View row = view;
        TaskHolder holder = null;

        if (row == null) {
            LayoutInflater inflater = ((Activity) mContext).getLayoutInflater();
            view = inflater.inflate(R.layout.taskview_each_item, null);

            holder = new TaskHolder();
            holder.title = (TextView)row.findViewById(R.id.title);
            holder.description = (TextView)row.findViewById(R.id.description);

            row.setTag(holder);
        }
        else
        {
            holder = (TaskHolder)row.getTag();
        }

        Task task = mdata[position];
        holder.title.setText(task.getTitle());
        holder.description.setText(task.getDescription());

        return row;
    }

    static class TaskHolder
    {
        TextView title;
        TextView description;
    }
}
