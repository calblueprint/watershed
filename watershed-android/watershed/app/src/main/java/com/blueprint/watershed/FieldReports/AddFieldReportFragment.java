package com.blueprint.watershed.FieldReports;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.FieldReports.CreateFieldReportRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Photos.Photo;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskFragment;
import com.blueprint.watershed.Users.User;

import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

public class AddFieldReportFragment extends Fragment implements View.OnClickListener {

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;

    private ImageButton mPickPhotoButton;
    private TextView mTitle;
    private RadioGroup mRating;
    private EditText mDescription;
    private Switch mUrgent;
    private ImageView mImage;

    private Photo mPhoto;

    private Task mTask;
    private MiniSite mMiniSite;

    // Camera Stuff
    private static final int CAMERA_REQUEST = 1337;
    private String mCurrentPhotoPath;


    public static AddFieldReportFragment newInstance(Task task, MiniSite site) {
        AddFieldReportFragment fragment = new AddFieldReportFragment();
        fragment.setTask(task);
        fragment.setMiniSite(site);
        return fragment;
    }

    public void setTask(Task task) { mTask = task; }
    public void setMiniSite(MiniSite site) { mMiniSite = site; }

    public void configureWithFieldReport(FieldReport fieldReport) {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_add_field_report, container, false);
        initializeViews(view);


        // Set OnClickListeners
        getTakePhotoButton().setOnClickListener(this);
        getSubmitFieldReportButton().setOnClickListener(this);

        return view;
    }

    public void initializeViews(View view) {
        mPickPhotoButton = (ImageButton) view.findViewById(R.id.report_add_photo);
        mPickPhotoButton.setOnClickListener(this);

        mRating = (RadioGroup) view.findViewById(R.id.health_group);
        mRating.check(R.id.health_3);

        mUrgent = (Switch) view.findViewById(R.id.field_report_urgent);
        mDescription = (EditText) view.findViewById(R.id.field_report_description);
        mImage = (ImageView) view.findViewById(R.id.report_photo);

        mTitle = (TextView) view.findViewById(R.id.report_title);
        String siteName;
        if (mMiniSite != null && mMiniSite.getName() != null) siteName = mMiniSite.getName();
        else siteName = "Mini Site";
        mTitle.setText("Field Report for " + siteName);
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
    }

    /*
     * Networking
     */
    public void createFieldReportRequest(FieldReport fieldReport) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateFieldReportRequest createFieldReportRequest = new CreateFieldReportRequest(getActivity(), fieldReport, params, new Response.Listener<FieldReport>() {
            @Override
            public void onResponse(FieldReport fieldReport) {
                Log.e("successful field report", "creation");
                mParentActivity.getSupportFragmentManager().popBackStack();
            }
        });

        mNetworkManager.getRequestQueue().add(createFieldReportRequest);
    }

    /*
     * View.OnClickListener methods
     */
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.report_add_photo:
                onTakePhotoButtonPressed();
                break;
        }
    }

    public void onTakePhotoButtonPressed() {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(mParentActivity.getPackageManager()) != null) {
            File photoFile = null;
            try { photoFile = createImageFile(); }
            catch (IOException ex) { Log.e("Field Report Photo", "Error"); }
            if (photoFile != null) {
                startActivityForResult(takePictureIntent, CAMERA_REQUEST);
            }
        }
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);

    }

    public void onSubmitFieldReportButtonPressed() {
        boolean hasErrors = false;

        if (mDescription.getText().toString().length() == 0) {
            mDescription.setError("Description can't be blank!");
            hasErrors = true;
        }

        Integer selectId = mRating.getCheckedRadioButtonId();

        if (selectId == -1) {
            Toast.makeText(mParentActivity, "Please select a health rating", Toast.LENGTH_SHORT).show();
            return;
        }

        RadioButton chosenRating = (RadioButton) mParentActivity.findViewById(selectId);
        String fieldReportHealth = chosenRating.getText().toString();
        Integer health = Integer.parseInt(fieldReportHealth);

        if (health < 1 || health > 5) {
            Toast.makeText(mParentActivity, "Invalid health rating", Toast.LENGTH_SHORT).show();
            return;
        }

        if (mPhoto == null) {
            Toast.makeText(mParentActivity, "Don't forget a photo!", Toast.LENGTH_SHORT).show();
            return;
        }

        if (hasErrors) return;

        FieldReport fieldReport = new FieldReport(mDescription.getText().toString(), health, mUrgent.isChecked(),
                                                  mPhoto, mParentActivity.getUser(), mMiniSite, mTask);

        createFieldReportRequest(fieldReport);
    }

    // Image Handling
    private File createImageFile() throws IOException {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(
                imageFileName,
                ".jpg",
                storageDir
        );
        mCurrentPhotoPath = "file:" + image.getAbsolutePath();
        return image;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        ImageView fieldReportImageView = (ImageView)view.findViewById(R.id.field_report_image);
        if (requestCode == CAMERA_REQUEST && resultCode == mParentActivity.RESULT_OK) {
            Bitmap photo = (Bitmap) data.getExtras().get("data");
            fieldReportImageView.setImageBitmap(photo);
        }
    }

    // Getters
    public Button getTakePhotoButton() { return mTakePhotoButton; }
    public Button getSubmitFieldReportButton() { return mSubmitFieldReportButton; }

    // Setters
    public void setTakePhotoButton(Button takePhotoButton) { mTakePhotoButton = takePhotoButton; }
    public void setSubmitFieldReportButton(Button submitFieldReportButton) { mSubmitFieldReportButton = submitFieldReportButton; }
}
