defmodule HandyApiWeb.JobDescriptorView do
  use HandyApiWeb, :view
  alias HandyApiWeb.JobDescriptorView

  def render("index.json", %{job_descriptors: job_descriptors}) do
    render_many(job_descriptors, JobDescriptorView, "job_descriptor.json")
  end

  def render("show.json", %{job_descriptor: job_descriptor}) do
    render_one(job_descriptor, JobDescriptorView, "job_descriptor.json")
  end

  def render("job_descriptor.json", %{job_descriptor: jd}) do
    %{
      id: jd.id,
      source_id: jd.source_id,
      name: jd.name,
      tolerance: jd.tolerance,
      frequency: jd.frequency,
      expected_at: jd.expected_at
    }
  end
end
