package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;

import java.util.Date;


public class TaskDetailFragment extends Fragment {

    private Task mTask;
    private OnFragmentInteractionListener mListener;
    private NetworkManager mNetworkManager;
    private MainActivity mMainActivity;


    public static TaskDetailFragment newInstance(Task task) {
        TaskDetailFragment taskFragment = new TaskDetailFragment();
        taskFragment.configureWithTask(task);
        return taskFragment;
    }

    public TaskDetailFragment() {
        // Required empty public constructor
    }

    public void configureWithTask(Task task) {
        mTask = task;
    }

    public void configureViewWithTask(View view, Task task) {
        ((TextView)view.findViewById(R.id.task_detail_title)).setText(task.getTitle());
        ((TextView)view.findViewById(R.id.task_detail_description)).setText(task.getDescription());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
         View view = inflater.inflate(R.layout.fragment_task_detail, container, false);
        configureViewWithTask(view, mTask);
        return view;
    }

    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mMainActivity = (MainActivity)activity;
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

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}
