import React from 'react'; 
import Nav from './NavBar';
import Tables from './Tables';
import TableView from './TableView';
import '../stylesheets/Home.css';

type HomeState = {
}

type HomeProps = {
}

class Home extends React.Component<HomeProps,HomeState>{
    render() {
        return(
            <div>
                <Nav/>
                <div className="view">
                    <Tables/>
                    <TableView/>
                </div>
            </div>
        )
    }
}

export default Home;
