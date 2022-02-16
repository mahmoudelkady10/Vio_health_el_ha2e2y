package com.example.medic_app.fmt;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.databinding.ViewDataBinding;

import com.linktop.MonitorDataTransmissionManager;
import com.linktop.infs.OnBpResultListener;
import com.linktop.whealthService.MeasureType;
import com.linktop.whealthService.task.BpTask;

import com.example.medic_app.bean.Bp;
import com.example.medic_app.health.App;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import technotown.technology.technoclinic.R;
import technotown.technology.technoclinic.databinding.FragmentBpBinding;
import lib.linktop.obj.DataFile;
import lib.linktop.sev.HmLoadDataTool;
import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;

/**
 * Created by ccl on 2017/2/7.
 * BpFragment
 */

public class BpFragment extends MeasureFragment
        implements OnBpResultListener {

    private Bp model;
    private BpTask mBpTask;

    public BpFragment() {
    }

    @Override
    public boolean startMeasure() {
        if (mBpTask != null) {
            if (mHcService.getBleDevManager().getBatteryTask().getPower() < 20) {
                toast("设备电量过低，请充电\nLow power.Please charge.");
                return false;
            }
            mBpTask.start();
        } else {
            if (MonitorDataTransmissionManager.getInstance().getBatteryValue() < 20) {
                toast("设备电量过低，请充电\nLow power.Please charge.");
                return false;
            }
            MonitorDataTransmissionManager.getInstance().startMeasure(MeasureType.BP);
        }
        return true;
    }

    @Override
    public void stopMeasure() {
        if (mBpTask != null) {
            mBpTask.stop();
        } else {
            MonitorDataTransmissionManager.getInstance().stopMeasure();
        }
    }

    @Override
    public void clickUploadData(View v) {
        if (model == null || model.isEmptyData()) {
            toast("不能上传空数据");
            return;
        }
        HmLoadDataTool.getInstance().uploadData(DataFile.DATA_BP, model
                //1.设置哪些测量数据要在推送中显示，SDK内已默认了推送参数的设定，app集成了推送后就可以在每次测量后收到相应推送，
                // 要推送哪些参数，就是类似如下方式设置了，若不满意可如下格式进行自定义设置。
//                , DataPair.create(DataKey.DESC_SBP, model.getSbp() + "mmHg")
//                , DataPair.create(DataKey.DESC_DBP, model.getDbp() + "mmHg")
//                , DataPair.create(DataKey.DESC_HR, model.getHr() + "bpm")
                // 2.若不想要有推送，这样设置
//                , (DataPair[]) null
        );
    }

    @Override
    public int getTitle() {
        return R.string.blood_pressure;
    }

    @Override
    protected ViewDataBinding onCreateBindingView(LayoutInflater inflater
            , @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        FragmentBpBinding binding = setBindingContentView(inflater, R.layout.fragment_bp, container);
        binding.setContent(this);
        binding.setShowUpload(App.isShowUploadButton);
        this.btnMeasure = binding.btnMeasure;
        model = new Bp();
        binding.setModel(model);
        return binding;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (mHcService != null) {
            mBpTask = mHcService.getBleDevManager().getBpTask();
            mBpTask.setOnBpResultListener(this);
        } else {
            //设置血压测量回调接口
            MonitorDataTransmissionManager.getInstance().setOnBpResultListener(this);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void reset() {
        model.reset();
    }

    @SuppressLint("NewApi")
    @Override
    public void onBpResult(final int systolicPressure, final int diastolicPressure, final int heartRate) {
        //测量时间（包括本demo其他测量项目的测量时间），既可以以点击按钮开始测试的那个时间为准，
        // 也可以以测量结果出来时为准，看需求怎么定义
        //这里demo演示，为了方便，采用后者。
        model.setTs(System.currentTimeMillis() / 1000L);
        Context context = getContext();
        assert context != null;
        SharedPreferences sharedPreferences = context.getSharedPreferences("Data", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString("systolic_pressure", String.valueOf(systolicPressure));
        editor.putString("diastolic_pressure", String.valueOf(diastolicPressure));
        editor.putString("heart_rate_bp", String.valueOf(heartRate));
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        editor.putString("date_bp", String.valueOf(LocalDateTime.now().format(myFormatObj)));
        editor.apply();
        model.setSbp(systolicPressure);
        model.setDbp(diastolicPressure);
        model.setHr(heartRate);
        resetState();
    }

    @Override
    public void onBpResultError() {
        toast(R.string.bp_result_error);
        resetState();
    }

    @Override
    public void onLeakError(int errorType) {
        resetState();
        Observable.just(errorType)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(error -> {
                    int textId = 0;
                    switch (error) {
                        case 0:
                            textId = R.string.leak_and_check;
                            break;
                        case 1:
                            textId = R.string.measurement_void;
                            break;
                        default:
                            break;
                    }
                    if (textId != 0)
                        Toast.makeText(getContext(), getString(textId), Toast.LENGTH_SHORT).show();
                });
    }

}
