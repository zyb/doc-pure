package com.zyb.mesos.docker;

import java.util.ArrayList;
import java.util.List;

import org.apache.mesos.MesosSchedulerDriver;
import org.apache.mesos.Protos;
import org.apache.mesos.Protos.CommandInfo;
import org.apache.mesos.Protos.ContainerInfo;
import org.apache.mesos.Protos.ExecutorID;
import org.apache.mesos.Protos.Filters;
import org.apache.mesos.Protos.FrameworkID;
import org.apache.mesos.Protos.FrameworkInfo;
import org.apache.mesos.Protos.MasterInfo;
import org.apache.mesos.Protos.Offer;
import org.apache.mesos.Protos.OfferID;
import org.apache.mesos.Protos.Resource;
import org.apache.mesos.Protos.SlaveID;
import org.apache.mesos.Protos.Status;
import org.apache.mesos.Protos.TaskID;
import org.apache.mesos.Protos.TaskInfo;
import org.apache.mesos.Protos.TaskState;
import org.apache.mesos.Protos.TaskStatus;
import org.apache.mesos.Scheduler;
import org.apache.mesos.SchedulerDriver;

public class TestScheduler implements Scheduler {
  public boolean runFlag = false;
  
  public static final String masterURI = "172.16.0.128:5050";
  
  public static final double CPUS_PER_TASK = 0.25;
  public static final double MEM_PER_TASK = 32;
  
  public static final String imageStr = "192.168.19.34:5000/centos:centos7";
  public static final String ccmd = "python -m SimpleHTTPServer 8000";
  
  @Override
  public void registered(SchedulerDriver driver, FrameworkID frameworkId,
      MasterInfo masterInfo) {
    System.out
        .println("Scheduler registered with id: " + frameworkId.getValue());
  }
  
  @Override
  public void reregistered(SchedulerDriver driver, MasterInfo masterInfo) {
    System.out.println("Scheduler re-registered.");
  }
  
  @Override
  public void resourceOffers(SchedulerDriver driver, List<Offer> offers) {
    if (runFlag) return;
    
    for (Offer offer : offers) {
      double offerCpus = 0;
      double offerMem = 0;
      for (Resource resource : offer.getResourcesList()) {
        if (resource.getName().equals("cpus")) {
          offerCpus += resource.getScalar().getValue();
        } else if (resource.getName().equals("mem")) {
          offerMem += resource.getScalar().getValue();
        }
      }
      System.out.println("Received offer " + offer.getId().getValue()
          + " with cpus: " + offerCpus + " and mem: " + offerMem);
      if (offerCpus < CPUS_PER_TASK && offerMem < MEM_PER_TASK) {
        System.out.println(offer.getId().getValue() + " resources not enough");
        break;
      }
      
      TaskID taskID = TaskID.newBuilder().setValue("zybDockerTask").build();
      System.out.println("Launching task " + taskID.getValue() + " on slave "
          + offer.getSlaveId().getValue() + ", hostname: "
          + offer.getHostname());
          
      // docker container
      ContainerInfo.DockerInfo dockerInfo = ContainerInfo.DockerInfo
          .newBuilder().setImage(imageStr)
          .setNetwork(ContainerInfo.DockerInfo.Network.HOST)
          .setPrivileged(false).build();
      ContainerInfo containerInfo = ContainerInfo.newBuilder()
          .setType(ContainerInfo.Type.DOCKER).setDocker(dockerInfo).build();
      // docker container task
      TaskInfo taskDK = TaskInfo.newBuilder()
          .setName("docker-task-" + taskID.getValue()).setTaskId(taskID)
          .setSlaveId(offer.getSlaveId()).setContainer(containerInfo)
          .setCommand(CommandInfo.newBuilder().setValue(ccmd))
          .addResources(Protos.Resource.newBuilder().setName("cpus")
              .setType(Protos.Value.Type.SCALAR).setScalar(
                  Protos.Value.Scalar.newBuilder().setValue(CPUS_PER_TASK)))
          .addResources(Protos.Resource.newBuilder().setName("mem")
              .setType(Protos.Value.Type.SCALAR).setScalar(
                  Protos.Value.Scalar.newBuilder().setValue(MEM_PER_TASK)))
          .build();
          
      Offer.Operation.Launch.Builder launch = Offer.Operation.Launch
          .newBuilder();
      launch.addTaskInfos(TaskInfo.newBuilder(taskDK));
      
      List<OfferID> offerIds = new ArrayList<OfferID>();
      offerIds.add(offer.getId());
      
      List<Offer.Operation> operations = new ArrayList<Offer.Operation>();
      
      Offer.Operation operation = Offer.Operation.newBuilder()
          .setType(Offer.Operation.Type.LAUNCH).setLaunch(launch).build();
          
      operations.add(operation);
      
      Filters filters = Filters.newBuilder().setRefuseSeconds(1).build();
      
      driver.acceptOffers(offerIds, operations, filters);
      
      runFlag = true;
      return;
    }
    
    System.err.println("All slaves don't have enough resource!");
  }
  
  @Override
  public void offerRescinded(SchedulerDriver driver, OfferID offerId) {
    // TODO Auto-generated method stub
    
  }
  
  @Override
  public void statusUpdate(SchedulerDriver driver, TaskStatus status) {
    System.out.println("Status update: task " + status.getTaskId().getValue()
        + " state is " + status.getState());
        
    if (status.getState() == TaskState.TASK_RUNNING) {
      System.out.println("Task " + status.getTaskId().getValue() + " running.");
    } else if (status.getState() == TaskState.TASK_FINISHED) {
      System.out.println("Task " + status.getTaskId().getValue() + " finished");
      driver.stop();
    } else if (status.getState() == TaskState.TASK_LOST
        || status.getState() == TaskState.TASK_KILLED
        || status.getState() == TaskState.TASK_FAILED) {
      System.err.println("Aborting because task "
          + status.getTaskId().getValue() + " is in unexpected state "
          + status.getState().getValueDescriptor().getName() + " with reason '"
          + status.getReason().getValueDescriptor().getName() + "'"
          + " from source '" + status.getSource().getValueDescriptor().getName()
          + "'" + " with message '" + status.getMessage() + "'");
      driver.abort();
    } else {
      System.err.println("Aborting because task "
          + status.getTaskId().getValue() + " is in unexpected state "
          + status.getState().getValueDescriptor().getName() + " with reason '"
          + status.getReason().getValueDescriptor().getName() + "'"
          + " from source 'driver.abort();"
          + status.getSource().getValueDescriptor().getName() + "'"
          + " with message '" + status.getMessage() + "'");
      driver.abort();
    }
  }
  
  @Override
  public void frameworkMessage(SchedulerDriver driver, ExecutorID executorId,
      SlaveID slaveId, byte[] data) {
    // TODO Auto-generated method stub
    
  }
  
  @Override
  public void disconnected(SchedulerDriver driver) {
    // TODO Auto-generated method stub
    
  }
  
  @Override
  public void slaveLost(SchedulerDriver driver, SlaveID slaveId) {
    // TODO Auto-generated method stub
    
  }
  
  @Override
  public void executorLost(SchedulerDriver driver, ExecutorID executorId,
      SlaveID slaveId, int status) {
    // TODO Auto-generated method stub
    
  }
  
  @Override
  public void error(SchedulerDriver driver, String message) {
    System.err.println("Error : " + message);
  }
  
  public static void main(String[] args) {
    FrameworkInfo frameworkInfo = FrameworkInfo.newBuilder()
        .setName("zybDockerScheduler").setUser("root").build();
        
    MesosSchedulerDriver driver = new MesosSchedulerDriver(new TestScheduler(),
        frameworkInfo, masterURI);
        
    int status = driver.run() == Status.DRIVER_STOPPED ? 0 : 1;
    
    // Ensure that the driver process terminates.
    driver.stop();
    
    System.exit(status);
  }
  
}
