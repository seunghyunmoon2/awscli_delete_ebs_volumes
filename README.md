# awscli_delete_ebs_volumes
## at the bottom there's a ENG version of README file.

---

# aws에서 엄청난 요금이 나온걸 발견했다.

베스핀의 opsnow에서 확인해봤는데, ec2 서비스에서 과금이 많이 됐더라.
그런데 ec2 서비스 사용한건 오토스케일링 테스트용으로 잠깐 올렸다가 내렸는데.. 라고 의문이 들었다.

ec2의 세부내역을 살펴보니 _볼륨(ebs)_쪽에서 엄청나게 과금되고 있던걸 확인.
> 볼륨 탭에 들어가보니 사용하지 않는 볼륨이 몇천개 쌓여있었다...

웹 콘솔에서 삭제하려니.. 엄청난 노가다라서 cli 이용한 자동화 스크립트를 만들었다.
aws에서 제공하는 api에서도 한개씩 삭제하는 api만 제공해서.. 더 효율적인 방법이 있겠지만(wait 활용, 비동기식) 일단 이걸로 충분해서 문제 해결을 했다.


for문을 돌리고 aws쪽의 응답까지 기다려야하지만 충분히 쓸만하다.

```
function deleteAvailableVolumes()
{
    for volume in `aws ec2 describe-volumes --filter "Name=status,Values=available" --query "Volumes[*].{ID:VolumeId}" --output text`
    do                                                                                
    aws ec2 delete-volume --volume-id $volume
    done   
}
```

클라우드 요금 관리를 위해서 공용으로 사용하는 계정의 경우 cron에 등록해서 주기적으로 삭제해줄 예정이다.

### 나중에 발견한거긴 하지만..
> ## asg 만들 때 '인스턴스 삭제 시 볼륨 삭제' 항목을 체크하면 알아서 삭제되긴 한다.


---


# a huge amount was billed from AWS

I looked it up using opsnow service(msp billing service) and found that the usage was from ec2 service. Although I didn't have much resource on it except I had run some tests on ASG(auto scaling group).

among ec2 items, the culprit was the ebs volumes.
> found thousands of available ebs volumes...

웹 콘솔에서 삭제하려니.. 엄청난 노가다라서 cli 이용한 자동화 스크립트를 만들었다.
I couldn't be bothered to manually delete each volume on AWS web consle. built a simple, sufficient enough bash script.


Not the best way, had to go through a for loop and wait for responsed from AWS, although it works.

```
function deleteAvailableVolumes()
{
    for volume in `aws ec2 describe-volumes --filter "Name=status,Values=available" --query "Volumes[*].{ID:VolumeId}" --output text`
    do                                                                                
    aws ec2 delete-volume --volume-id $volume
    done   
}
```

클라우드 요금 관리를 위해서 공용으로 사용하는 계정의 경우 cron에 등록해서 주기적으로 삭제해줄 예정이다.
I have a lot on my hands at work, which means I can't just log in to AWS console and do this every day. So my team and I have decided to run this using _cron_ at one point.

### later discovery. yet...
> ## when creating asg, you can give 'delete volumes on instance delete' option on which will solve this from the beginnig.
