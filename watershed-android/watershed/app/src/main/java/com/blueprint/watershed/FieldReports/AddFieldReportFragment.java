package com.blueprint.watershed.FieldReports;

import android.annotation.TargetApi;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
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
import com.blueprint.watershed.Utilities.Utility;

import org.json.JSONObject;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

public class AddFieldReportFragment extends Fragment implements View.OnClickListener {

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;

    private RelativeLayout mLayout;
    private ImageButton mPickPhotoButton;
    private TextView mTitle;
    private RatingBar mRating;
    private EditText mDescription;
    private Switch mUrgent;
    private ImageView mImage;

    private Photo mPhoto;

    private Task mTask;
    private MiniSite mMiniSite;

    // Camera Stuff
    protected static final int CAMERA_REQUEST = 1337;
    protected static final int SELECT_PHOTO_REQUEST = 69;
    protected String mCurrentPhotoPath;

    // Dialog Stuff
    protected static final String DIALOG_TAG = "PickPhotoTypeDialog";
    protected static final int DIALOG_REQUEST_CODE = 200;


    public static AddFieldReportFragment newInstance(Task task, MiniSite site) {
        AddFieldReportFragment fragment = new AddFieldReportFragment();
        fragment.setTask(task);
        fragment.setMiniSite(site);
        return fragment;
    }

    public void setTask(Task task) { mTask = task; }
    public void setMiniSite(MiniSite site) { mMiniSite = site; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_add_field_report, container, false);
        initializeViews(view);
        return view;
    }

    public void initializeViews(View view) {
        mLayout = (RelativeLayout) view.findViewById(R.id.report_layout);
        mPickPhotoButton = (ImageButton) view.findViewById(R.id.report_add_photo);
        mPickPhotoButton.setOnClickListener(this);

        mRating = (RadioGroup) view.findViewById(R.id.health_group);
        mRating.check(R.id.health_3);

        mUrgent = (Switch) view.findViewById(R.id.field_report_urgent);
        mDescription = (EditText) view.findViewById(R.id.report_description);
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

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.save_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.save:
                onSubmitFieldReportButtonPressed();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    /*
     * View.OnClickListener methods
     */
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.report_add_photo:
                onPickPhotoButtonPressed();
                break;
        }
    }

    @SuppressWarnings("deprecation")
    @TargetApi(16)
    private void onPickPhotoButtonPressed() {
        if (mPhoto != null) {
            mPhoto = null;
            mImage.setImageDrawable(null);
            if (Utility.currentVersion() >= 16) {
                mPickPhotoButton.setBackground(mParentActivity.getResources().getDrawable(R.drawable.ic_camera));
            } else {
                mPickPhotoButton.setBackgroundDrawable(mParentActivity.getResources().getDrawable(R.drawable.ic_camera));
            }
            mImage.invalidate();
            mPickPhotoButton.invalidate();
        } else {
            openAddPhotoDialog();
        }
    }

    /**
     * Handles taking a photo - starts new activity
     */
    public void onTakePhotoButtonPressed(){
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(mParentActivity.getPackageManager()) != null) {
            File photoFile = null;

            try { photoFile = createImageFile(); }
            catch (IOException ex) { Log.e("Mini Site Photo", "Error"); }

            if (photoFile != null) {
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(photoFile));
                startActivityForResult(takePictureIntent, CAMERA_REQUEST);
            }
        }
    }

    /**
     * Creates an Image File
     * @return A file
     * @throws IOException
     */
    private File createImageFile() throws IOException {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(imageFileName, ".jpg", storageDir);
        mCurrentPhotoPath = image.getAbsolutePath();
        return image;
    }

    /**
     * Opens dialog to pick between taking or selecting a photo
     */
    public void openAddPhotoDialog() {
        PickPhotoTypeDialog dialog = PickPhotoTypeDialog.newInstance();
        dialog.setTargetFragment(this, DIALOG_REQUEST_CODE);
        dialog.show(mParentActivity.getSupportFragmentManager(), DIALOG_TAG);
    }


    /**
     * Handles selecting a photo - starts new activity
     */
    public void onSelectPhotoButtonPressed() {
        Intent intent = new Intent(Intent.ACTION_PICK,
                android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, SELECT_PHOTO_REQUEST);
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

        final FieldReport fieldReport = new FieldReport(mDescription.getText().toString(), health, mUrgent.isChecked(),
                                                        mPhoto, mParentActivity.getUser(), mMiniSite, mTask);

        Utility.hideKeyboard(mParentActivity, mLayout);
        new Thread(new Runnable() {
            @Override
            public void run() {
                createFieldReportRequest(fieldReport);
            }
        }).start();
    }


    /**
     * Handing our activity results
     * @param requestCode Number telling us which intent was called
     * @param resultCode Number telling us if the request was ok
     * @param data Data passed back by the activity
     */
    @SuppressWarnings("deprecation")
    @TargetApi(16)
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        Bitmap photo = null;
        if (requestCode == CAMERA_REQUEST && resultCode == MainActivity.RESULT_OK) {
            // Get the dimensions of the View
            int targetW = mImage.getWidth();
            int targetH = mImage.getHeight();

            // Get the dimensions of the bitmap
            BitmapFactory.Options bmOptions = new BitmapFactory.Options();
            bmOptions.inJustDecodeBounds = true;
            BitmapFactory.decodeFile(mCurrentPhotoPath, bmOptions);
            int photoW = bmOptions.outWidth;
            int photoH = bmOptions.outHeight;

            // Determine how much to scale down the image
            int scaleFactor = 0;
            if (targetW > 0 && targetH > 0) scaleFactor = Math.min(photoW/targetW, photoH/targetH);

            // Decode the image file into a Bitmap sized to fill the View
            bmOptions.inJustDecodeBounds = false;
            bmOptions.inSampleSize = scaleFactor;
            bmOptions.inPurgeable = true;

            photo = BitmapFactory.decodeFile(mCurrentPhotoPath, bmOptions);

        }
        else if (requestCode == SELECT_PHOTO_REQUEST && resultCode == MainActivity.RESULT_OK) {
            Uri targetUri = data.getData();

            try { photo = BitmapFactory.decodeStream(mParentActivity.getContentResolver().openInputStream(targetUri)); }
            catch (FileNotFoundException e) { e.printStackTrace(); }
        }

        Bitmap scaledBitmap = null;

        if (photo != null)  {
            int height = photo.getHeight() / 6;
            int width = photo.getWidth() / 6;
            scaledBitmap = Bitmap.createScaledBitmap(photo, width, height, false);
        }

        if (scaledBitmap != null) {
            mPhoto = new Photo(scaledBitmap);
            mImage.invalidate();
            if (Utility.currentVersion() >= 16) {
                mPickPhotoButton.setBackground(mParentActivity.getResources().getDrawable(R.drawable.ic_delete));
            } else {
                mPickPhotoButton.setBackgroundDrawable(mParentActivity.getResources().getDrawable(R.drawable.ic_delete));
            }
            mPickPhotoButton.invalidate();
            mImage.setImageBitmap(scaledBitmap);
        }
    }

    /*
     * Networking
     */
    public void createFieldReportRequest(FieldReport fieldReport) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateFieldReportRequest createFieldReportRequest = new CreateFieldReportRequest(mParentActivity, fieldReport, params, new Response.Listener<FieldReport>() {
            @Override
            public void onResponse(FieldReport fieldReport) {
                Log.e("successful field report", "creation");
                mTask.setFieldReport(fieldReport);
                mParentActivity.getSupportFragmentManager().popBackStack();
            }
        });

        mNetworkManager.getRequestQueue().add(createFieldReportRequest);
    }


    /**
     * Dialog that allows users to choose between taking and selecting a photo.
     */
    public static class PickPhotoTypeDialog extends DialogFragment {

        public static PickPhotoTypeDialog newInstance() { return new PickPhotoTypeDialog(); }

        @Override
        @NonNull
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            String[] photoArray = { "Select Photo", "Take Photo" };
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setTitle("Select a Photo Option!")
                    .setItems(photoArray, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            if (!(getTargetFragment() instanceof AddFieldReportFragment)) {
                                Log.e("Fragment Error", "Can't even fragment");
                                return;
                            }
                            AddFieldReportFragment fragment = (AddFieldReportFragment) getTargetFragment();

                            if (which == 0) fragment.onSelectPhotoButtonPressed();
                            else fragment.onTakePhotoButtonPressed();
                        }
                    })
                    .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    });

            return builder.create();
        }
    }
}
