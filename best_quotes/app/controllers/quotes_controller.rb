class QuotesController < Rulers::Controller
  def a_quote
    render :a_quote, :noun => :winking
  end

  def quote_1
    quote_1 = FileModel.find(1)
    render :quote, :obj => quote_1
  end

  def index
    if params['submitter'].nil?
      quotes = FileModel.all
    else
      quotes = FileModel.find_all_by_submitter(params['submitter'])
    end
    render :index, :quotes => quotes
  end

  def show
    quote = FileModel.find(params["id"])
    @ua = request.user_agent
    @quote = quote

    render_response :quote
  end

  def new_quote
    attrs = {
      "submitter" => "web user",
      "quote" => "A picture is worth one k pixels",
      "attribution" => "Me"
    }
    m = FileModel.create attrs
    render :quote, :obj => m
  end

  def update_quote
    quote_1 = FileModel.find(1)
    quote_1['submitter'] = params['submitter']
    quote_1.save

    render :quote, obj: quote_1
  end
end
