# Interaction Performance Forward Tests v1.2.0

状态：`executed_self_forward_test`

版本：`1.2.0`；version code：`10200`

边界：这是当前 Codex 读取完整 Skill 后执行的自前向契约测试，不是独立盲测、Kling/Seedance 生成结果或用户成片验证。下列 Prompt 只证明 v1.2.0 的路由与压缩规则能够产出目标结构；单边接触暗示仍为 `experimental`。

## I1 单向交流信号

输入：8 秒演员 Cut，人物向镜头招手打招呼；镜头前对象不可见。

结论：`unilateral_signal → direct_action`。对象隐藏后动作不依赖接触或外部支撑。

同类覆盖：招手致意、召唤注意、制止、指方向、飞吻、比心均保持 `unilateral_signal → direct_action`；若任务要求角色让出具体空间并等待对方靠近或进入，则改走 `spatial_invitation → invite_and_wait`。

<!-- PROMPT_OUTPUT_START -->
8秒稳定单镜中近景，无台词。人物先自然看向镜头区域，随后只抬起右手，在肩部下方完成一次短小、方向清楚的招手；动作停止后，手保持开放一拍，人物以友好、明确的目光等待。主角色保持为画面唯一表演主体，既有背景维持不变。
<!-- PROMPT_OUTPUT_END -->

## I2 对镜击掌

输入：Kling 3.0 Standard，8 秒演员 Cut；与用户击掌，但用户、用户的手和新增物体不能出现。

结论：`brief_reciprocal_contact → implied_contact_experimental`。输出标签为“单边接触暗示（待验证）”，不声称真实接触。

同类覆盖：碰拳、轻碰只有在角色一侧动作无需持续支撑且隐藏后仍有中等以上可读性时，才允许相同实验路由；否则改为邀请等待或冲突。

成片验收边界：固定同一首帧、Kling 模型与工作流、8 秒时长、画幅和 Prompt，分别检查外部实体、是否新增物体、动作路径、掌面朝向、单次前送与回弹，以及观众能否读出击掌邀请与接触暗示。

<!-- PROMPT_OUTPUT_START -->
8秒稳定单镜中近景，无台词。时间范围仅作为节奏参考，动作可以根据表演自然提前或延后；所有变化连续衔接，不在分段边界停顿、重置或重新起势。

【0–1.4s｜建立互动】
人物自然看向镜头区域，身体放松，双臂保持首帧的自然状态。

【1.4–3.5s｜竖掌邀请】
人物只让动作手从身体同侧直接向上抬起，前臂向上展开；手掌保持竖直，手指朝上，完整掌面朝向镜头，在肩部高度停稳。动作路径不横跨胸前或脸部。

【3.5–5.8s｜单次接触暗示】
竖直掌面保持朝向镜头，沿镜头轴完成一次短距离前送，随即产生一次轻微回弹；动作在遮挡面部或贴近镜头前停止，不追加第二次前送。

【5.8–8s｜自然收势】
动作手从回弹位置自然降低，人物重新清楚地对上镜头，以轻松、友好的状态结束。主角色保持为画面唯一表演主体，既有背景维持不变。
<!-- PROMPT_OUTPUT_END -->

## I3 持续握手

输入：人物与不可见用户持续握手，外部身体局部禁止出现。

结论：不输出完成握手的 Prompt。若用户接受降级，则只表现角色伸出手发起邀请并等待；否则 `incompatible`。

同类覆盖：搀扶、拉人均依赖外部支撑或拉力，隐藏对象时不能编译成单边完成。

## I4 拥抱与牵手

输入：与不可见对象拥抱或牵手，并要求互动已经完成。

结论：持续接触需要外部身体提供接触面和支撑，隐藏对象后不能物理成立；返回需求冲突，不用单边拟态伪造完成。

## I5 物体交换

输入：接过不可见用户递来的杯子，但杯子禁止出现。

结论：`object_transfer → incompatible`。物体重量与结束归属无法同时满足，不输出空气抓握 Prompt。

同类覆盖：递杯、接手机、收礼物、喂食均要求必要物体已在首帧存在或作为明确输入素材绑定并获准保留；仅允许新增物体不能通过门禁。

## I6 画外声音

输入：人物听到画外呼唤，对方不得入镜。

结论：`offscreen_audio → direct_action`。使用具体声音刺激，目标保持画外。

同类覆盖：呼唤、警告、提问、打断分别使用可定位的一次声音、关键词或停顿，不把说话者具象化。

<!-- PROMPT_OUTPUT_START -->
One continuous 6-second close-up. The character is occupied with a quiet task. When their name is called once from the established off-screen direction, their gaze lifts toward that same direction; after recognizing the voice, the tension around the mouth releases and they hold an open, attentive listening state through the cut. Keep the existing frame and visible subject stable.
<!-- PROMPT_OUTPUT_END -->

## I7 画外身体刺激

输入：不可见对象拍肩，但任何外部身体局部不得出现。

结论：默认 `offscreen_physical → incompatible`。独立声音线索只能支持待验证实验，不晋升为稳定完成方案。

同类覆盖：拍肩、拉住、触碰都先检查外部接触面、支撑与拉力；持续依赖不可见对象时保持冲突。

## I8 空间邀请

输入：人物让出位置，邀请镜头前对象坐下，对象不得出现。

结论：`spatial_invitation → invite_and_wait`。结束停在让出空间和等待，不写对方已经坐下。

同类覆盖：让座、示意靠近、示意进入都停在角色一侧的空间开放和等待，不虚构对方到达。

## I9 镜头表面动作

输入：人物擦拭镜头表面。

结论：`lens_interaction`。必须提示近镜头手部形变、面部遮挡和接触面风险；Motion Control 不能被当作实体排除工具。

同类覆盖：敲镜头、擦镜头、遮镜头分别检查动作手是否属于主角色、是否在允许身体范围内，以及遮挡和畸变风险。

## I10 首帧门禁与所有权

- 首帧存在用户明确禁用的第二人物、外部身体局部或道具：`source_preflight: block`，不输出视频 Prompt。
- 首帧不可访问且硬排除决定可运行性：先请求素材或明确确认。
- 主角色自己的另一只手默认属于 `allowed_owners`；只有用户明确限制可见身体范围时才阻断或改构图。
- 禁止新增实体的回归分别覆盖第二人物、外部身体局部、无关道具、未知归属影子和未知归属倒影；主角色首帧已有的自然影子或倒影按所有权判断。
