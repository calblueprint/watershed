package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.blueprint.watershed.R;

import java.util.Date;


public class TaskDetailFragment extends Fragment {

    private Task mTask;
    private OnFragmentInteractionListener mListener;
    private String mTitle;
    private String mDescription;
    private Integer mSiteId;
    private Integer mAssignerId;
    private Integer mAssigneeId;
    private Boolean mComplete;
    private Date mDueDate;


    public static TaskDetailFragment newInstance(Task task) {
        TaskDetailFragment fragment = new TaskDetailFragment();
        Bundle args = new Bundle();
        args.putString("title", task.getTitle());
        args.putString("description", task.getDescription());
        args.putInt("siteId", task.getSiteId());
        args.putInt("assigneeId", task.getAssigneeId());
        args.putInt("assignerId", task.getAssignerId());
        args.putInt("siteId", task.getSiteId());
        args.putBoolean("complete", task.getComplete());
        args.putString("date", task.getDueDate().toString());
        fragment.setArguments(args);
        return fragment;
    }
    public TaskDetailFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mTitle = getArguments().getString("title");
            mDescription = getArguments().getString("description");
            mSiteId = getArguments().getInt("siteId");
            mAssignerId = getArguments().getInt("assignerId");
            mAssigneeId = getArguments().getInt("assigneeId");
            mComplete = getArguments().getBoolean("complete");
            String dueDate = getArguments().getString("date");
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
         View view = inflater.inflate(R.layout.fragment_task_detail, container, false);
        ((TextView)view.findViewById(R.id.task_detail_title)).setText(mTitle);
        ((TextView)view.findViewById(R.id.task_detail_description)).setText(mDescription);
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
