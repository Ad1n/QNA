shared_examples_for "updated question" do
  before { request }

  it "question attribute" do
    question.reload
    expect(question.title).method(param_for[:equals]).call eq 'New title'
    expect(question.body).method(param_for[:equals]).call eq 'New body'
  end

  it "receives response status like in param_for status" do
    expect(response.status).to eq(param_for[:status])
  end
end

