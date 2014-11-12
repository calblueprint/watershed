package com.blueprint.watershed;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.ListFragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

public class TaskFragment extends ListFragment {

    private OnFragmentInteractionListener mListener;
    private ListView listView1;
    private ArrayList<Task> mTaskList;
    private MainActivity parentActivity;
    private TaskAdapter mTaskAdapter;
    private RequestHandler mRequestHandler;


    public static TaskFragment newInstance(int option) {
        TaskFragment fragment = new TaskFragment();
        Bundle args = new Bundle();
        args.putInt("option", option);
        fragment.setArguments(args);
        return fragment;
    }

    public TaskFragment(){
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mRequestHandler = RequestHandler.getInstance(getActivity().getApplicationContext());
        parentActivity = (MainActivity)getActivity();
        mTaskList = new ArrayList<Task>();
        if (getArguments() != null) {
            int option = getArguments().getInt("option");
            getTasksRequest();
            switch (option) {
                case 0: //populates with tasks that you are assigned
                    mTaskList.add(new Task("Title 1", "Description 1 ", "1", 1, 1, true, new Date()));
                    mTaskList.add(new Task("Title 2", "Description 2 ", "1", 1, 1, true, new Date()));
                    mTaskList.add(new Task("Title 3", "Description 3 ", "1", 1, 1, true, new Date()));
                    break;

                case 1: //populates with all tasks
                    mTaskList.add(new Task("Title 4", "Description 4 ", "1", 1, 1, true, new Date()));
                    mTaskList.add(new Task("Title 5", "Description 5 ", "1", 1, 1, true, new Date()));
                    mTaskList.add(new Task("Title 6", "Description 6 ", "1", 1, 1, true, new Date()));
                    break;
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_task_list, container, false);

        listView1 = (ListView)finalView.findViewById(android.R.id.list);
        mTaskAdapter = new TaskAdapter(getActivity(),R.layout.taskview_each_item, mTaskList);
        listView1.setAdapter(mTaskAdapter);
        return finalView;
    }

    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id){
        Task taskClicked = this.mTaskList.get(position);
        TaskDetailFragment detailFragment = TaskDetailFragment.newInstance(taskClicked);
        parentActivity.replaceFragment(detailFragment);
    }


    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);

        try {
            mListener = (OnFragmentInteractionListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    private void getTasksRequest(){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        // TODO(mark): URL and mapper should be generalized
        String url = "https://intense-reaches-1457.herokuapp.com/api/v1/tasks";
        final ObjectMapper mapper = new ObjectMapper();
        mapper.setPropertyNamingStrategy(PropertyNamingStrategy.CAMEL_CASE_TO_LOWER_CASE_WITH_UNDERSCORES);

        BaseRequest request = new BaseRequest(Request.Method.GET, url, new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sitesJson = jsonObject.get("tasks").toString();
                            ArrayList<Task> tasks = mapper.readValue(sitesJson, new TypeReference<ArrayList<Task>>() {
                            });
                            setTasks(tasks);
                            Log.i("task count", Integer.toString(tasks.size()));
                            mTaskAdapter.notifyDataSetChanged();
                            Log.e("response", jsonObject.toString());
                        } catch (Exception e) {
                            Log.e("Json exception", "in task list fragment" + e.toString());
                        }
                    }
                }
                , getActivity()){};

        mRequestHandler.getRequestQueue().add(request);
    }

    private void setTasks(ArrayList<Task> tasks){
        mTaskList.clear();
        for (Task task : tasks){
            mTaskList.add(task);
        }
    };

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}
