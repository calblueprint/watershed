package com.blueprint.watershed.Tasks;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.Response;
import com.android.volley.toolbox.JsonObjectRequest;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.MiniSites.MiniSiteInfoListRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.CreateTaskRequest;
import com.blueprint.watershed.Networking.Tasks.EditTaskRequest;
import com.blueprint.watershed.Networking.Users.UsersRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Users.User;
import com.blueprint.watershed.Utilities.Utility;

import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * Created by charlesx on 2/19/15.
 * Abstract fragment from
 */
public abstract class TaskAbstractFragment extends Fragment {

    private static final String CREATE = "create";
    private static final int REQUEST_CODE = 200;

    protected RelativeLayout mLayout;
    protected EditText mTitleField;
    protected EditText mDescriptionField;
    protected TextView mAssigneeField;
    protected TextView mDueDateField;
    protected TextView mMiniSiteId;
    protected MainActivity mParentActivity;
    protected NetworkManager mNetworkManager;

    private Date mDate;
    private User mUser;
    private MiniSite mMiniSite;
    private List<User> mUsers;
    private List<MiniSite> mMiniSites;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        getFieldObjects();
    }

    /**
     * Gets the users and sites so that we can pick from them.
     */
    private void getFieldObjects() {
        mUsers = mParentActivity.getUsers();
        if (mUsers == null) getUsers();
        getMiniSites();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_create_task, container, false);
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    /**
     * Gets users, and checks if the MainActivity has it loaded already. If it doesn't might as well use it there!
     */
    private void getUsers() {
        UsersRequest request = new UsersRequest(mParentActivity, new Response.Listener<ArrayList<User>>() {
            @Override
            public void onResponse(ArrayList<User> users) {
                mUsers = users;
                mParentActivity.setUsers(users);
            }
        });
        mNetworkManager.getRequestQueue().add(request);
    }

    private void getMiniSites() {
        MiniSiteInfoListRequest request = new MiniSiteInfoListRequest(mParentActivity, new Response.Listener<ArrayList<MiniSite>>() {
            @Override
            public void onResponse(ArrayList<MiniSite> miniSites) { mMiniSites = miniSites; }
        });
        mNetworkManager.getRequestQueue().add(request);
    }

    /**
     * Initializes all the views for the form.
     */
    public void setButtonListeners() {
        mLayout = (RelativeLayout) mParentActivity.findViewById(R.id.create_task_layout);
        Utility.setKeyboardListener(mParentActivity, mLayout);

        Button submitButton = (Button) mParentActivity.findViewById(R.id.create_task_submit);
        submitButton.setOnClickListener(validateAndSubmit());

        mTitleField = (EditText) mParentActivity.findViewById(R.id.create_task_title);
        mDescriptionField = (EditText) mParentActivity.findViewById(R.id.create_task_description);

        mAssigneeField = (TextView) mParentActivity.findViewById(R.id.create_task_assignee);
        mAssigneeField.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) { openUserDialog(); }
        });


        mDueDateField = (TextView) mParentActivity.findViewById(R.id.create_task_due_date);
        mDueDateField.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) { openDateDialog(); }
        });

        mMiniSiteId = (TextView) mParentActivity.findViewById(R.id.create_task_site);
        mMiniSiteId.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) { openSiteDialog(); }
        });
    }

    private View.OnClickListener validateAndSubmit() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean hasErrors = false;
                if (mTitleField.getText().toString().length() == 0) {
                    setEmpty("Title", mTitleField);
                    hasErrors = true;
                }

                if (mDescriptionField.getText().toString().length() == 0) {
                    setEmpty("Description", mDescriptionField);
                    hasErrors = true;
                }

                if (mMiniSite == null) {
                    setEmpty("Minisite", mDescriptionField);
                    hasErrors = true;
                }

                if (mDate == null) {
                    setEmpty("Deadline", mDescriptionField);
                    hasErrors = true;
                }

                if (mUser == null) {
                    setEmpty("User", mDescriptionField);
                    hasErrors = true;
                }

                if (hasErrors) return;

                submitListener();
            }
        };
    }

    private void setEmpty(String field, EditText editText) { editText.setError(field + " can't be blank!"); }

    private void openUserDialog() {
        PickUserDialog newFragment = PickUserDialog.newInstance(mUsers);
        newFragment.setTargetFragment(this, REQUEST_CODE);
        newFragment.show(mParentActivity.getSupportFragmentManager(), "userPicker");
    }

    private void openDateDialog() {
        TaskDateDialog newFragment = TaskDateDialog.newInstance();
        newFragment.setTargetFragment(this, REQUEST_CODE);
        newFragment.show(mParentActivity.getSupportFragmentManager(), "timePicker");
    }

    private void openSiteDialog() {
        PickMiniSite newFragment = PickMiniSite.newInstance(mMiniSites);
        newFragment.setTargetFragment(this, REQUEST_CODE);
        newFragment.show(mParentActivity.getSupportFragmentManager(), "timePicker");
    }

    /**
     * Creates a request to create/edit a task.
     * Returns back to the task index fragment
     * @param task - Task object
     */
    public void createTaskRequest(Task task, final String type) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        JsonObjectRequest request;
        if (type.equals(CREATE)) {
            request = new CreateTaskRequest(mParentActivity, task, params, new Response.Listener<Task>() {
                @Override
                public void onResponse(Task task) {
                    TaskFragment taskFragment = TaskFragment.newInstance(0);
                    mParentActivity.replaceFragment(taskFragment);
                    Log.e("successful task", "creation");
                }
            });
        } else {
            request = new EditTaskRequest(mParentActivity, task, params, new Response.Listener<Task>() {
                @Override
                public void onResponse(Task task) {
                    mParentActivity.getSupportFragmentManager().popBackStack();
                    Log.i("successful task", "editing");
                }
            });
        }

        mNetworkManager.getRequestQueue().add(request);
    }

    /**
     * Creates a task object that is pass to createTaskRequest
     * @param type - Type of request, CREATE or EDIT
     */
    public void createTask(String type, Task task) {
        if (type.equals(CREATE)) task = new Task();
        task.setTitle(mTitleField.getText().toString());
        task.setDescription(mDescriptionField.getText().toString());
        task.setAssignerId(mParentActivity.getUserId());
        task.setDueDate(mDate);
        task.setAssigneeId(mUser.getId());
        task.setMiniSiteId(mMiniSite.getId());

        createTaskRequest(task, type);
    }

    public abstract void submitListener();

    public void setDate(int year, int month, int day) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, day);
        mDate = calendar.getTime();
        mDueDateField.setText(new SimpleDateFormat("MM/dd/yyyy").format(mDate));
    }

    public void setUser(User user) {
        mUser = user;
        mAssigneeField.setText(mUser.getName());
    }

    public void setMiniSite(MiniSite site) {
        mMiniSite = site;
        mMiniSiteId.setText(site.getName());
    }


    /**
     * Creates a dialog allowing you to pick a date
     */
    public static class TaskDateDialog extends DialogFragment
            implements DatePickerDialog.OnDateSetListener {

        public static TaskDateDialog newInstance() { return new TaskDateDialog(); }

        @Override
        @NonNull
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            // Use the current date as the default date in the picker
            final Calendar c = Calendar.getInstance();
            int year = c.get(Calendar.YEAR);
            int month = c.get(Calendar.MONTH);
            int day = c.get(Calendar.DAY_OF_MONTH);

            // Create a new instance of DatePickerDialog and return it
            return new DatePickerDialog(getActivity(), this, year, month, day);
        }

        public void onDateSet(DatePicker view, int year, int month, int day) {
            // Do something with the date chosen by the user
            if (!(getTargetFragment() instanceof TaskAbstractFragment)) Log.e("can't", "even fragment");
            TaskAbstractFragment fragment = (TaskAbstractFragment) getTargetFragment();
            fragment.setDate(year, month, day);
            dismiss();
        }
    }

    /**
     * Creates a dialog that picks a user
     */
    public static class PickUserDialog extends DialogFragment {

        protected List<User> mUsers;

        public static PickUserDialog newInstance(List<User> users) {
            PickUserDialog dialog = new PickUserDialog();
            dialog.setUsers(users);
            return dialog;
        }

        @Override
        @NonNull
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setTitle(R.string.pick_user)
                   .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                       @Override
                       public void onClick(DialogInterface dialogInterface, int i) {
                           dialogInterface.dismiss();
                       }
                   });

            if (mUsers != null && mUsers.size() > 0) {
                builder.setItems(getUserNames(), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        Log.i("user", mUsers.get(i).getName());
                        if (!(getTargetFragment() instanceof TaskAbstractFragment)) Log.e("can't", "even fragment");
                        TaskAbstractFragment fragment = (TaskAbstractFragment) getTargetFragment();
                        fragment.setUser(mUsers.get(i));
                    }
                });
            } else {
                builder.setMessage(R.string.loading_users);
            }

            return builder.create();

        }

        public String[] getUserNames() {
            String[] names = new String[mUsers.size()];
            for (int i = 0; i < mUsers.size(); i++) names[i] = mUsers.get(i).getName();
            return names;
        }

        private void setUsers(List<User> users) { mUsers = users; }
    }

    /**
     * Creates a dialog that picks a user
     */
    public static class PickMiniSite extends DialogFragment {

        protected List<MiniSite> mMiniSites;

        public static PickMiniSite newInstance(List<MiniSite> miniSites) {
            PickMiniSite dialog = new PickMiniSite();
            dialog.setUsers(miniSites);
            return dialog;
        }

        @Override
        @NonNull
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setTitle(R.string.pick_user)
                    .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            dialogInterface.dismiss();
                        }
                    });

            if (mMiniSites != null && mMiniSites.size() > 0) {
                builder.setItems(getUserNames(), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        Log.i("user", mMiniSites.get(i).getName());
                        if (!(getTargetFragment() instanceof TaskAbstractFragment)) Log.e("can't", "even fragment");
                        TaskAbstractFragment fragment = (TaskAbstractFragment) getTargetFragment();
                        fragment.setMiniSite(mMiniSites.get(i));
                    }
                });
            } else {
                builder.setMessage(R.string.loading_users);
            }

            return builder.create();

        }

        public String[] getUserNames() {
            String[] names = new String[mMiniSites.size()];
            for (int i = 0; i < mMiniSites.size(); i++) names[i] = mMiniSites.get(i).getName();
            return names;
        }

        private void setUsers(List<MiniSite> miniSites) { mMiniSites = miniSites; }
    }
}
