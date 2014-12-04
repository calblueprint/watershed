package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.app.ProgressDialog;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.TaskListRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

public class TaskFragment extends ListFragment {

    private OnFragmentInteractionListener mListener;
    private ListView listView1;
    private ArrayList<Task> mTaskList;
    private MainActivity parentActivity;
    private TaskAdapter mTaskAdapter;
    private NetworkManager mNetworkManager;

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
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        parentActivity = (MainActivity)getActivity();
        mTaskList = new ArrayList<Task>();
        if (getArguments() != null) {
            int option = getArguments().getInt("option");
            getTasksRequest();
            switch (option) {
                case 0: //populates with tasks that you are assigned
                    break;

                case 1: //populates with all tasks
                    break;
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_task_list, container, false);
        parentActivity.openSpinner(finalView);
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

        TaskListRequest taskListRequest = new TaskListRequest(getActivity(), params, new Response.Listener<ArrayList<Task>>() {
            @Override
            public void onResponse(ArrayList<Task> tasks) {
                setTasks(tasks);
                mTaskAdapter.notifyDataSetChanged();
            }
        });

        mNetworkManager.getRequestQueue().add(taskListRequest);
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
