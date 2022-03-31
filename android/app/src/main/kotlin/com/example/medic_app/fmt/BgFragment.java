package com.example.medic_app.fmt;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;

import androidx.annotation.Nullable;
import androidx.databinding.ObservableField;
import androidx.databinding.ViewDataBinding;

import com.linktop.MonitorDataTransmissionManager;
import com.linktop.constant.BgPagerCaliCode;
import com.linktop.infs.OnBgResultListener;
import com.linktop.whealthService.MeasureType;
import com.linktop.whealthService.task.BgTask;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

import com.example.medic_app.bean.Bg;
import technotown.technology.technoclinic.R;
import technotown.technology.technoclinic.databinding.FragmentBgBinding;

/**
 * Created by ccl on 2018/1/23.
 * 血糖
 */

public class BgFragment extends MeasureFragment implements OnBgResultListener {

    private Bg model;
    private ObservableField<String> event = new ObservableField<>("");
    private BgTask mBgTask;

    public BgFragment() {
    }

    @Override
    protected ViewDataBinding onCreateBindingView(LayoutInflater inflater
            , @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        FragmentBgBinding binding = setBindingContentView(inflater, R.layout.fragment_bg, container);
        binding.setContent(this);
        this.btnMeasure = binding.btnMeasure;
        model = new Bg();
        binding.setModel(model);
        binding.setEvent(event);
        final Context context = getContext();
        if (context != null) {
            final String[] codes = BgPagerCaliCode.values();
            ArrayAdapter<String> adapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_dropdown_item, Arrays.asList(codes));
            binding.spin1.setAdapter(adapter);
            binding.spin1.setSelection(20, true);
            binding.spin1.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    MonitorDataTransmissionManager.getInstance().setBgPagerCaliCode(codes[position]);
                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {

                }
            });
        }
        return binding;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (mHcService != null) {
            mBgTask = mHcService.getBleDevManager().getBgTask();
            mBgTask.setOnBgResultListener(this);
        } else {
            MonitorDataTransmissionManager.getInstance().setOnBgResultListener(this);
        }
    }

    @Override
    public boolean startMeasure() {
        model.setTs(System.currentTimeMillis());
        if (mBgTask != null) {
            if (mBgTask.isModuleExist()) {
                mBgTask.start();
                return true;
            } else {
                toast("This Device's Bg module is not exist.");
                return false;
            }
        } else {
            if (MonitorDataTransmissionManager.getInstance().isBsModuleExist()) {
                MonitorDataTransmissionManager.getInstance().startMeasure(MeasureType.BG);
                return true;
            } else {
                toast("This Device's Bg module is not exist.");
                return false;
            }
        }
    }

    @Override
    public void stopMeasure() {
        if (mBgTask != null) {
            mBgTask.stop();
        } else {
            MonitorDataTransmissionManager.getInstance().stopMeasure();
        }
        event.set("");
    }

    @Override
    public void clickUploadData(View v) {

    }

    @Override
    public int getTitle() {
        return R.string.blood_glucose;
    }

    @Override
    public void reset() {
        model.reset();
    }

    /**
     * 返回事件
     */
    @SuppressLint("NewApi")
    @Override
    public void onBgEvent(int eventId, Object obj) {
        switch (eventId) {
            case BgTask.EVENT_PAGER_IN:
                event.set(getString(R.string.test_strip_inserted));
                break;
            case BgTask.EVENT_PAGER_READ:
                event.set(getString(R.string.test_strip_ready));
                break;
            case BgTask.EVENT_BLOOD_SAMPLE_DETECTING:
                event.set(getString(R.string.bg_value_calculating));
                break;
            case BgTask.EVENT_TEST_RESULT:
                event.set(getString(R.string.bg_result));
                Context context = getContext();
                assert context != null;
                SharedPreferences sharedPreferences = context.getSharedPreferences("Data", Context.MODE_PRIVATE);
                SharedPreferences.Editor editor = sharedPreferences.edit();
                editor.putString("bg_measure", String.valueOf(Double.parseDouble(String.valueOf(obj)) * 18));
                DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                editor.putString("date_bg", String.valueOf(LocalDateTime.now().format(myFormatObj)));
                editor.apply();
                model.setValue(((double) obj) * 18);
                resetState();
                break;
            default:
                Log.e("onBsEvent", "eventId:" + eventId + ", obj:" + obj);
                break;
        }
    }

    /**
     * 返回异常
     * 当返回事件{@link BgTask#EVENT_PAGER_IN} 后任意时候拔出试条，则报异常{@link BgTask#EXCEPTION_PAGER_OUT};
     * 当返回事件{@link BgTask#EVENT_PAGER_IN} 后设备检测到试条是被使用过的，则报异常{@link BgTask#EXCEPTION_PAPER_USED};
     * 当返回事件{@link BgTask#EVENT_BLOOD_SAMPLE_DETECTING}后60secs內未计算出结果，则报异常{@link BgTask#EXCEPTION_TIMEOUT_FOR_DETECT_BLOOD_SAMPLE};
     * 所有异常上报的同时，SDK内部将自动结束血糖的测试。
     */
    @Override
    public void onBgException(int exception) {
        switch (exception) {
            case BgTask.EXCEPTION_PAGER_OUT:
                toast(R.string.test_strip_is_not_inserted);
                break;
            case BgTask.EXCEPTION_PAPER_USED:
                toast(R.string.test_strip_is_used);
                break;
            case BgTask.EXCEPTION_TESTING_PAPER_OUT:
                toast(R.string.test_strip_out);
                break;
//            case BgTask.EXCEPTION_TIMEOUT_FOR_CHECK_BLOOD_SAMPLE:
//                toast(R.string.collecting_sample_timeout);
//                break;
            case BgTask.EXCEPTION_TIMEOUT_FOR_DETECT_BLOOD_SAMPLE:
                toast(R.string.calculate_bg_value_timeout);
                break;
            default:
                Log.e("onBsException", "exception:" + exception);
                break;
        }
        event.set("");
        resetState();
    }
}
