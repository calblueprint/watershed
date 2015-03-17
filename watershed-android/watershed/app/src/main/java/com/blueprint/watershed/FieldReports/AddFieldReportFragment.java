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
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Switch;
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
    private View view;
    private Button mTakePhotoButton;
    private Button mSubmitFieldReportButton;

    // Camera Stuff
    private static final int CAMERA_REQUEST = 1337;
    private String mCurrentPhotoPath;


    public static AddFieldReportFragment newInstance() {
        return new AddFieldReportFragment();
    }

    public AddFieldReportFragment() {
        // Required empty public constructor
    }

    public void configureWithFieldReport(FieldReport fieldReport) {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mParentActivity = (MainActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_add_field_report, container, false);
        setTakePhotoButton((Button) view.findViewById(R.id.take_photo_button));
        setSubmitFieldReportButton((Button) view.findViewById(R.id.submit_field_report_button));


        // Set OnClickListeners
        getTakePhotoButton().setOnClickListener(this);
        getSubmitFieldReportButton().setOnClickListener(this);

        return view;
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
        Log.e("HIT DAT ENDPOINT", "Hit It");
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateFieldReportRequest createFieldReportRequest = new CreateFieldReportRequest(getActivity(), fieldReport, params, new Response.Listener<FieldReport>() {
            @Override
            public void onResponse(FieldReport fieldReport) {
                Log.e("successful field report", "creation");
            }
        });

        mNetworkManager.getRequestQueue().add(createFieldReportRequest);
    }

    /*
     * View.OnClickListener methods
     */
    public void onClick(View view) {
        Log.e("Click", "Button");
        switch (view.getId()) {
            case R.id.take_photo_button:
                Log.e("Click", "Take Photo");
                // Take the photo
                onTakePhotoButtonPressed(view);
                break;
            case R.id.submit_field_report_button:
                // Send the request to make the field report
                onSubmitFieldReportButtonPressed(view);
                break;
        }
    }

    public void onTakePhotoButtonPressed(View takePhotoButton){
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(mParentActivity.getPackageManager()) != null) {
            File photoFile = null;
            try {
                photoFile = createImageFile();
            } catch (IOException ex) {
                Log.e("Field Report Photo", "Error");
            }
            if (photoFile != null) {
                //takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT,
                //Uri.fromFile(photoFile));
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

    public void onSubmitFieldReportButtonPressed(View fieldReportButton){
        String fieldReportDescription = ((EditText)view.findViewById(R.id.field_report_description)).getText().toString();

        RadioGroup healthGroup = (RadioGroup)view.findViewById(R.id.health_group);
        Integer selectId = healthGroup.getCheckedRadioButtonId();
        if (selectId == -1) {
            Toast toast = Toast.makeText(mParentActivity.getApplicationContext(), "Please select a health rating", Toast.LENGTH_SHORT);
            toast.show();
            return;
        }
        String fieldReportHealth = ((RadioButton)view.findViewById(selectId)).getText().toString();
        Integer fieldReportHealthInt = Integer.parseInt(fieldReportHealth);

        ImageView image = (ImageView)view.findViewById(R.id.field_report_image);
        Bitmap fieldReportPhoto = ((BitmapDrawable)image.getDrawable()).getBitmap();

        Boolean urgency = ((Switch)view.findViewById(R.id.field_report_urgent)).isChecked();

        // TODO(max): Make sure to replace user, minisite, and task with the corresponding objects.
        Task fieldReportTask = mParentActivity.getFieldReportTask();
        MiniSite fieldReportMiniSite = new MiniSite();
        fieldReportMiniSite.setId(fieldReportTask.getMiniSiteId());
        FieldReport fieldReport = new FieldReport(fieldReportDescription, fieldReportHealthInt, urgency, new Photo(fieldReportPhoto), new User(), fieldReportMiniSite, fieldReportTask);

        createFieldReportRequest(fieldReport);

        TaskFragment taskFragment = TaskFragment.newInstance(0);
        mParentActivity.replaceFragment(taskFragment);
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
