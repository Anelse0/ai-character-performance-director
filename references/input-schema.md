# 输入语义对象(完整)

本文件是 `SKILL.md` 输入策略的完整参考。用户始终只需给自然语言;本 skill 内部把请求归一化为下列语义对象,但绝不强迫用户填表。

`SKILL.md` 只保留最常用的核心字段;需要交互、复杂运镜、Kling 动作控制或原地锁定时,再按对应 reference 使用下列扩展字段。字段的语义与推导规则分别见:

- 表演字段:`references/acting-craft.md`、`references/acting-core.md`
- 镜头字段:`references/camera-direction.md`
- 交互与实体字段:`references/interaction-performance.md`
- Kling 动作/原地字段:`references/kling-motion-control.md`、`adapters/kling-3.md`

```yaml
mode: auto | actor_cut | narrative | environment
model: both | seedance2 | kling3_standard | kling3_omni | kling3_motion_control
duration:
characters:
relationship:
analysis_depth: auto | light | standard | deep
style_contract:
given_circumstances:
target_person:
interaction_class: unilateral_signal | brief_reciprocal_contact | sustained_contact | object_transfer | offscreen_audio | offscreen_physical | spatial_invitation | lens_interaction
target_presence: visible | offscreen_audio | implied
target_visualization: allowed | forbidden
reciprocity: none | brief | sustained
contact_requirement: none | implied | required
external_support: none | person | object
legibility_without_target: high | medium | low
render_mode: direct_action | implied_contact_experimental | invite_and_wait | visible_interaction | incompatible
entity_contract:
  allowed_owners:
  forbidden_owners:
  allowed_existing_props:
  new_entity_policy: allow | forbid
  visible_body_scope:
  reflection_policy: preserve | forbid_new
  shadow_policy: preserve | forbid_new
  source_preflight: pass | block
scene_state:
trigger:
want:
stakes:
obstacle:
tactic:
expected_effect:
turning_trigger:
hide_or_conflict:
display_policy: reveal | restrain | deny | redirect
intensity: L1_leak | L2_breach | L3_dysregulation
dialogue:
shot_constraints:
camera_intent:
viewer_relation:
movement_driver:
camera_subject:
camera_unit:
  start_frame:
  trigger:
  spatial_transform: static | translate | rotate | optical | focus
  trajectory:
  subject_coupling: follow | lead | parallel | counter | reveal | leave_behind | independent
  speed_profile:
  stabilization_texture:
  framing_correction:
  stop_condition:
  end_frame:
screen_direction:
execution_source: prompt | ui_control | start_end_frames | video_reference | custom_multishot
execution_status: supported | experimental
references:
known_failures:
ending:
kling_workflow: auto | standard_single | custom_multi_shot | motion_control
spatial_control: auto | prompt_only | motion_control
motion_scope: localized | upper_body | full_body
motion_precision: approximate | repeatable | exact
motion_concurrency:
head_turn:
face_occlusion:
identity_sensitivity:
motion_reference: none | uploaded_video | motion_library
facial_element:
gaze_target:
gaze_behavior: establish | naturally_adjust | reacquire
expression_references:
spatial_lock: none | soft | hard
root_motion: allowed | bounded | locked
```

## 使用原则

- 只在缺失信息会改变表演或镜头策略时追问,否则做最小合理推断,并在结果中用一行说明。
- 内部字段不直接堆入最终 Prompt;只保留模型真正需要的可观察信息。
- 快车道请求(单人单镜、≤8 秒、无交互/对白/复杂动作/实体硬排除)通常只需要 `mode / model / duration / target_person / want / tactic / turning_trigger / camera_intent / ending` 这一核心子集;其余字段留空即可。
