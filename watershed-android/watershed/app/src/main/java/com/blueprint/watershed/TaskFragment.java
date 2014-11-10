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

import java.util.Date;

public class TaskFragment extends ListFragment {

    private OnFragmentInteractionListener mListener;
    private ListView listView1;
    private Task mTaskList[];
    private MainActivity parentActivity;


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
        parentActivity = (MainActivity)getActivity();
        if (getArguments() != null) {
            int option = getArguments().getInt("option");
            switch (option) {
                case 0: //populates with tasks that you are assigned
                    mTaskList = new Task[]
                            {
                                    new Task("Title 1", "Description 1 ", 1, 1, 1, true, new Date()),
                                    new Task("Title 2", "Description 2 ", 1, 1, 1, true, new Date()),
                                    new Task("Title 3", "Description 3 ", 1, 1, 1, true, new Date()),
                            };
                    break;

                case 1: //populates with all tasks
                    mTaskList = new Task[]
                            {
                                    new Task("Title 4", "Description 1 ", 1, 1, 1, true, new Date()),
                                    new Task("Title 5", "Description 2 ", 1, 1, 1, true, new Date()),
                                    new Task("Title 6", "Description 3 ", 1, 1, 1, true, new Date()),
                            };
                    break;

            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_task_list, container, false);

        listView1 = (ListView)finalView.findViewById(android.R.id.list);
        TaskAdapter arrayAdapter = new TaskAdapter(getActivity(),R.layout.taskview_each_item, mTaskList);
        listView1.setAdapter(arrayAdapter);
        return finalView;
    }

    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id){
        Task taskClicked = this.mTaskList[position];
        TaskDetailFragment detailFragment = new TaskDetailFragment();
        Toast.makeText(getActivity(), taskClicked.getTitle() + " Clicked!", Toast.LENGTH_SHORT).show();
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

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}
