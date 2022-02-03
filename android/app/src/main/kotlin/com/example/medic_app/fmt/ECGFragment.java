package com.example.medic_app.fmt;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.annotation.StringRes;
import androidx.databinding.ObservableField;
import androidx.databinding.ViewDataBinding;

import com.linktop.MonitorDataTransmissionManager;
import com.linktop.constant.IUserProfile;
import com.linktop.infs.OnEcgResultListener;
import com.linktop.whealthService.MeasureType;
import com.linktop.whealthService.task.EcgTask;

import com.example.medic_app.activity.ECGLargeActivity;
import com.example.medic_app.bean.ECG;
import com.example.medic_app.bean.UserProfile;
import com.example.medic_app.health.App;
import technotown.technology.technoclinic.R;
import technotown.technology.technoclinic.databinding.FragmentEcgBinding;
import com.example.medic_app.utils.AlertDialogBuilder;
import com.example.medic_app.widget.WaveSurfaceView;
import com.example.medic_app.widget.wave.ECGDrawWave;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lib.linktop.obj.DataFile;
import lib.linktop.sev.HmLoadDataTool;

/**
 * Created by ccl on 2017/2/7.
 */

public class ECGFragment extends MeasureFragment
        implements OnEcgResultListener {

    private static final String TAG = "ECGFragment";
    private ECG model;
    private final ObservableField<String> pagerSpeedStr = new ObservableField<>();
    private final ObservableField<String> gainStr = new ObservableField<>();
    private final StringBuilder ecgWaveBuilder = new StringBuilder();
    private EcgTask mEcgTask;
    private WaveSurfaceView waveView;
    private ECGDrawWave ecgDrawWave;

    public ECGFragment() {
    }

    @Override
    public boolean startMeasure() {
        waveView.reply();
        if (mEcgTask != null) {
            if (mEcgTask.isModuleExist()) {
                mEcgTask.initEcgTg();
                mEcgTask.start();
                return true;
            } else {
                toast("This Device's ECG module is not exist.");
                return false;
            }
        } else {
            if (MonitorDataTransmissionManager.getInstance().isEcgModuleExist()) {
                MonitorDataTransmissionManager.getInstance().startMeasure(MeasureType.ECG);
                return true;
            } else {
                toast("This Device's ECG module is not exist.");
                return false;
            }
        }
    }

    @Override
    public void stopMeasure() {
        if (mEcgTask != null) {
            mEcgTask.stop();
        } else {
            MonitorDataTransmissionManager.getInstance().stopMeasure();
        }
        waveView.pause();
    }

    @Override
    public void clickUploadData(View v) {
        if (model == null || model.isEmptyData()) {
            toast("不能上传空数据");
            return;
        }
        HmLoadDataTool.getInstance().uploadData(DataFile.DATA_ECG, model);
    }

    @Override
    public int getTitle() {
        return R.string.ecg;
    }

    @Override
    protected ViewDataBinding onCreateBindingView(@Nullable LayoutInflater inflater
            , @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        FragmentEcgBinding binding = setBindingContentView(inflater, R.layout.fragment_ecg, container);
        binding.setContent(this);
        binding.setShowUpload(App.isShowUploadButton);
        this.btnMeasure = binding.btnMeasure;
        model = new ECG();
        binding.setModel(model);
        ecgDrawWave = new ECGDrawWave();
        ecgDrawWave.setPagerSpeed(ECGDrawWave.PagerSpeed.VAL_25MM_PER_SEC);
        ecgDrawWave.setGain(ECGDrawWave.Gain.VAL_10MM_PER_MV);
        waveView = binding.waveView;
        waveView.setDrawWave(ecgDrawWave);
        binding.setPagerSpeedStr(pagerSpeedStr);
        binding.setGainStr(gainStr);
        pagerSpeedStr.set(ecgDrawWave.getPagerSpeed().getDesc());
        gainStr.set(ecgDrawWave.getGain().getDesc());
        /**
         * Whether the ECG automatically ends the measurement.
         * @return true. It means ECG will keep measuring until all results has value.
         * @return false. It means ECG will keep measuring until you call stop api.
         */
        if (mEcgTask != null) {
            binding.sw.setChecked(mEcgTask.isAutoEnd());
        } else {
            binding.sw.setChecked(MonitorDataTransmissionManager.getInstance().isEcgAutoEnd());
        }
        binding.sw.setOnCheckedChangeListener((compoundButton, autoEnd) -> {
            /**
             * Set ECG to automatically end the measurement.
             * Default is “true”. If you do not want to automatically end the measurement,
             * set it “false”.
             */
            if (mEcgTask != null) {
                mEcgTask.setAutoEnd(autoEnd);
            } else {
                MonitorDataTransmissionManager.getInstance().setEcgAutoEnd(autoEnd);
            }
        });
        return binding;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        waveView.pause();
        IUserProfile userProfile = new UserProfile("ccl", 1, 27, 170, 60);
        if (mHcService != null) {
            mEcgTask = mHcService.getBleDevManager().getEcgTask();
            mEcgTask.setDrawWaveDataArray(true);
            mEcgTask.setOnEcgResultListener(this);
            //Import user profile makes the result more accurate.
            mEcgTask.setUserProfile(userProfile);
        } else {
            MonitorDataTransmissionManager.getInstance().setEcgDrawWaveDataArray(true);
            MonitorDataTransmissionManager.getInstance().setUserProfile(userProfile);
            MonitorDataTransmissionManager.getInstance().setOnEcgResultListener(this);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void reset() {
        model.reset();
        ecgWaveBuilder.setLength(0);
        ecgDrawWave.clear();
    }

    long startTs = 0L;
    int i = 0;

    /*
     * 心电图数据点
     * */
    @Override
    public synchronized void onDrawWave(Object data) {
        if (data instanceof int[]) {
            Log.i(TAG, "onDrawWave -> int[]");
            int[] dataArray = (int[]) data;
            for (int d : dataArray) {
                //将数据点在心电图控件里描绘出来
                ecgDrawWave.addData(d);
                //将数据点存入容器，查看大图使用
                ecgWaveBuilder.append(d).append(",");
            }
        } else if (data instanceof Integer) {
            Log.i(TAG, "onDrawWave -> int");
            //将数据点在心电图控件里描绘出来
            int d = (int) data;
            ecgDrawWave.addData(d);
            //将数据点存入容器，查看大图使用
            ecgWaveBuilder.append(d).append(",");
        }
    }

    @Override
    public void onSignalQuality(int quality) {
        Log.e("ECG", "onSignalQuality:" + quality);
    }

    @Override
    public void onECGValues(int key, int value) {
        Context context = getContext();
        assert context != null;
        SharedPreferences sharedPreferences = context.getSharedPreferences("Data", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        switch (key) {
            case RRI_MAX:
                model.setRRMax(value);
                editor.putString("rrmax", String.valueOf(value));
                editor.apply();
                break;
            case RRI_MIN:
                model.setRRMin(value);
                editor.putString("rrmin", String.valueOf(value));
                editor.apply();
                break;
            case HR:
                model.setHr(value);
                editor.putString("heart_rate_ecg", String.valueOf(value));
                editor.apply();
                break;
            case HRV:
                model.setHrv(value);
                editor.putString("hrv", String.valueOf(value));
                editor.apply();
                break;
            case MOOD:
                model.setMood(value);
                editor.putString("mood", String.valueOf(value));
                editor.apply();
                break;
            case RR://Respiratory rate.
                model.setRr(value);
                editor.putString("respiratory_rate", String.valueOf(value));
                editor.apply();
                break;
        }
    }

    /*
     * 心电图测量持续时间,该回调一旦触发说明一次心电图测量结束
     * */
    @SuppressLint("NewApi")
    @Override
    public void onEcgDuration(long duration) {
        final long l = (System.currentTimeMillis() - startTs) / 1000L;
        startTs = 0L;
        i = 0;
        model.setDuration(duration);
        model.setTs(System.currentTimeMillis() / 1000L);
        String ecgWave = ecgWaveBuilder.toString();
        ecgWave = ecgWave.substring(0, ecgWave.length() - 1);
        model.setWave(ecgWave);
        Context context = getContext();
        assert context != null;
        SharedPreferences sharedPreferences = context.getSharedPreferences("Data", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString("duration_ecg", String.valueOf(duration));
        editor.putString("ecg_wave", ecgWave);
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        editor.putString("date_ecg", String.valueOf(LocalDateTime.now().format(myFormatObj)));
        editor.apply();
        resetState();
    }

    public void openECGLarge(View v) {
        Intent intent = new Intent(mActivity, ECGLargeActivity.class);
        intent.putExtra("pagerSpeed", ecgDrawWave.getPagerSpeed());
        intent.putExtra("gain", ecgDrawWave.getGain());
        intent.putExtra("model", model);
        startActivity(intent);
    }

    /*
     * 点击设置时间基准(走纸速度)
     * 该值反应心电图x轴的幅度，设置的值这里没做保存，请自行保存，以便下次启动该页面时自动设置已保存的值
     * */
    public void clickSetPagerSpeed(View v) {
        int checkedItem = 0;
        final ECGDrawWave.PagerSpeed[] pagerSpeeds = ECGDrawWave.PagerSpeed.values();
        for (int i = 0; i < pagerSpeeds.length; i++) {
            if (pagerSpeeds[i].equals(ecgDrawWave.getPagerSpeed())) {
                checkedItem = i;
                break;
            }
        }
        onShowSingleChoiceDialog(R.string.pager_speed, pagerSpeeds, checkedItem
                , (dialog, which) -> {
                    ECGDrawWave.PagerSpeed pagerSpeed = pagerSpeeds[which];
                    ecgDrawWave.setPagerSpeed(pagerSpeed);
                    pagerSpeedStr.set(pagerSpeed.getDesc());
                    dialog.dismiss();
                });
    }

    /*
     * 点击设置增益
     * 该值反应心电图y轴的幅度，设置的值这里没做保存，请自行保存，以便下次启动该页面时自动设置已保存的值
     * */
    public void clickSetGain(View v) {
        int checkedItem = 0;
        final ECGDrawWave.Gain[] gains = ECGDrawWave.Gain.values();
        for (int i = 0; i < gains.length; i++) {
            if (gains[i].equals(ecgDrawWave.getGain())) {
                checkedItem = i;
                break;
            }
        }
        onShowSingleChoiceDialog(R.string.gain, gains, checkedItem
                , new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        ECGDrawWave.Gain gain = gains[which];
                        ecgDrawWave.setGain(gain);
                        gainStr.set(gain.getDesc());
                        dialog.dismiss();
                    }
                });
    }

    private void onShowSingleChoiceDialog(@StringRes int titleResId, ECGDrawWave.ECGValImp[] arrays
            , int checkedItem, DialogInterface.OnClickListener listener) {
        int length = arrays.length;
        CharSequence[] items = new CharSequence[length];
        for (int i = 0; i < length; i++) {
            items[i] = arrays[i].getDesc();
        }
        new AlertDialogBuilder(mActivity)
                .setTitle(titleResId)
                .setSingleChoiceItems(items, checkedItem, listener)
                .setNegativeButton(android.R.string.cancel, null)
                .create()
                .show();
    }
}
