package com.blueprint.watershed.FieldReports;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Switch;
import android.widget.Toast;

import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.TaskFragment;
import com.blueprint.watershed.Users.User;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class AddFieldReportFragment extends Fragment implements View.OnClickListener {

    private OnFragmentInteractionListener mListener;
    private View view;
    private Button mTakePhotoButton;
    private Button mSubmitFieldReportButton;

    // Camera Stuff
    private static final int CAMERA_REQUEST = 1337;
    private String mCurrentPhotoPath;


    public static AddFieldReportFragment newInstance() {
        AddFieldReportFragment addFieldReportFragment = new AddFieldReportFragment();
        return addFieldReportFragment;
    }

    public AddFieldReportFragment() {
        // Required empty public constructor
    }

    public void configureWithFieldReport(FieldReport fieldReport) {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
        }
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

    /*
     * View.OnClickListener methods
     */
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.take_photo_button:
                // Take the photo
                onTakePhotoButtonPressed(view);
                break;
            case R.id.submit_field_report_button:
                // Send the request to make the field report
                onSubmitFieldReportButtonPressed(view);
                break;
        }
    }

    public void onTakePhotoButtonPressed(View view){
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
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

    public void onSubmitFieldReportButtonPressed(View fieldReportButton){
        String fieldReportDescription = ((EditText)findViewById(R.id.field_report_description)).getText().toString();

        RadioGroup healthGroup = (RadioGroup) findViewById(R.id.health_group);
        Integer selectId = healthGroup.getCheckedRadioButtonId();
        if (selectId == -1){
            Toast toast = Toast.makeText(getApplicationContext(), "Please select a health rating", Toast.LENGTH_SHORT);
            toast.show();
            return;
        }
        String fieldReportHealth = ((RadioButton) findViewById(selectId)).getText().toString();
        Integer fieldReportHealthInt = Integer.parseInt(fieldReportHealth);

        ImageView image = (ImageView) findViewById(R.id.field_report_image);
        Bitmap fieldReportPhoto = ((BitmapDrawable)image.getDrawable()).getBitmap();

        Boolean urgency = ((Switch)findViewById(R.id.field_report_urgent)).isChecked();

        FieldReport fieldReport = new FieldReport(fieldReportDescription, fieldReportHealthInt, urgency, fieldReportPhoto, new User(), new MiniSite());

        TaskFragment taskFragment = TaskFragment.newInstance(0);
        replaceFragment(taskFragment);
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

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        ImageView fieldReportImageView = (ImageView)findViewById(R.id.field_report_image);
        if (requestCode == CAMERA_REQUEST && resultCode == RESULT_OK) {
            Bitmap photo = (Bitmap) data.getExtras().get("data");
            fieldReportImageView.setImageBitmap(photo);
        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    // Getters
    public Button getTakePhotoButton() { return mTakePhotoButton; }
    public Button getSubmitFieldReportButton() { return mSubmitFieldReportButton; }

    // Setters
    public void setTakePhotoButton(Button takePhotoButton) { mTakePhotoButton = takePhotoButton; }
    public void setSubmitFieldReportButton(Button submitFieldReportButton) { mSubmitFieldReportButton = submitFieldReportButton; }
}
