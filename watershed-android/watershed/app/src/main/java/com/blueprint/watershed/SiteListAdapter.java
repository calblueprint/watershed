package com.blueprint.watershed;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

/**
 * Created by Mark Miyashita on 10/14/14.
 */
public class SiteListAdapter extends ArrayAdapter<Site> {

    Context context;
    int layoutResourceId;
    Task data[] = null;

    public SiteListAdapter(Context context, int layoutResourceId, Task[] data) {
        super(context, layoutResourceId, data);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.data = data;
    }

    @Override
    public View getView(int position, View convertview, ViewGroup parent) {
        View row = convertview;
        TaskHolder holder = null;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new TaskHolder();
            holder.title = (TextView)row.findViewById(R.id.title);
            holder.description = (TextView)row.findViewById(R.id.description);

            row.setTag(holder);
        } else {
            holder = (TaskHolder)row.getTag();
        }

        Task task = data[position];
        holder.title.setText(task.getTitle());
        holder.description.setText(task.getDescription());

        return row;
    }

    static class TaskHolder {
        TextView title;
        TextView description;
    }
}
