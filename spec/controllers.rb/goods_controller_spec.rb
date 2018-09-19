RSpec.describe GoodsController, type: :controller do
    let(:user) { create(:user) }
  
    let(:valid_attributes) {
      { name: 'new name' }
    }
  
    let(:invalid_attributes) {
      { name: nil }
    }
  
    before do
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload)
      @tokens = session.login
    end
  
    describe 'GET #index' do
      let!(:good) { create(:good, user: user) }
  
      it 'returns a success response' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        get :index
        expect(response).to be_successful
        expect(response_json.size).to eq 1
        expect(response_json.first['id']).to eq todo.id
      end
  
      # usually there's no need to test this kind of stuff 
      # within the resources endpoints
      # the quick spec is here only for the presentation purposes
      it 'unauth without cookie' do
        get :index
        expect(response).to have_http_status(401)
      end
    end
  
    describe 'GET #show' do
      let!(:todo) { create(:todo, user: user) }
  
      it 'returns a success response' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        get :show, params: { id: todo.id }
        expect(response).to be_successful
      end
    end
  
    describe 'POST #create' do
  
      context 'with valid params' do
        it 'creates a new Todo' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          expect {
            post :create, params: { todo: valid_attributes }
          }.to change(Good, :count).by(1)
        end
  
        it 'renders a JSON response with the new todo' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          post :create, params: { todo: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.content_type).to eq('application/json')
          expect(response.location).to eq(good_url(Good.last))
        end
  
        it 'unauth without CSRF' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          post :create, params: { good: valid_attributes }
          expect(response).to have_http_status(401)
        end
      end
  
      context 'with invalid params' do
        it 'renders a JSON response with errors for the new good' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          post :create, params: { good: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end
  
    describe 'PUT #update' do
      let!(:good) { create(:good, user: user) }
  
      context 'with valid params' do
        let(:new_attributes) {
          { name: 'Super secret name' }
        }
  
        it 'updates the requested good' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          put :update, params: { id: good.id, good: new_attributes }
          good.reload
          expect(good.name).to eq new_attributes[:name]
        end
  
        it 'renders a JSON response with the good' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          put :update, params: { id: good.to_param, good: valid_attributes }
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end
  
      context 'with invalid params' do
        it 'renders a JSON response with errors for the good' do
          request.cookies[JWTSessions.access_cookie] = @tokens[:access]
          request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
          put :update, params: { id: good.to_param, good: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq('application/json')
        end
      end
    end
  
    describe 'DELETE #destroy' do
      let!(:good) { create(:good, user: user) }
  
      it 'destroys the requested good' do
        request.cookies[JWTSessions.access_cookie] = @tokens[:access]
        request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
        expect {
          delete :destroy, params: { id: good.id }
        }.to change(Good, :count).by(-1)
      end
    end
end
