package com.blueprint.watershed;

import android.app.ListActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ArrayAdapter;

import java.util.ArrayList;


public class TaskActivity extends ListActivity {

    ArrayList<Task> TaskList;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task);

        TaskList = new ArrayList<Task>();

        ArrayAdapter<Task> arrayAdapter =
                new ArrayAdapter<Task>(this,android.R.layout.simple_list_item_1, TaskList);

        TaskList.setAdapter(arrayAdapter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.task, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    void getTasks() {
        TaskList.add(new Task());
        TaskList.add(new Task());
        TaskList.add(new Task());
        TaskList.add(new Task());
        TaskList.add(new Task());
    }
}
